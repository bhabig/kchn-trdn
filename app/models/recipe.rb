class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates_presence_of :name, :cook_time, :instructions, :category

  attr_reader :ingredients_attributes

  def ingredient_attributes=(t)
    t.delete_if{|n,h| h[:name].empty?}
    t.each do |num, hash|
      ingredient = Ingredient.find_or_create_by(hash.except("measurement"))
      self.save
      self.ingredients << ingredient unless self.ingredients.include?(ingredient)
      self.recipe_ingredients.last.update(measurement: hash[:measurement])
    end
  end

  def ingredient_select(hash)
    hash.each do |name, info_hash|
      @ingredient = Ingredient.find_by(name: name)
      if info_hash['id'].to_i == 1 && info_hash['measurement'] != ""
        self.ingredients << @ingredient unless !@ingredient || self.ingredients.include?(@ingredient)
        RecipeIngredient.find_by(ingredient_id: @ingredient.id, recipe_id: self.id).update(measurement: info_hash["measurement"])
      elsif info_hash['id'].to_i == 1 && info_hash['measurement'] == ""
        return "sorry, all ingredients need measurements"
      else
        self.remove_on_update(@ingredient) unless !self.ingredients.include?(@ingredient)
      end
    end
  end

  def remove_on_update(ingredient)
    self.ingredients.delete(ingredient)
  end

  #method to make cook_time readable
end
