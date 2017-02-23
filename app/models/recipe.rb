class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates_presence_of :name, :cook_time, :instructions

  attr_reader :ingredient_attributes

  def ingredient_attributes=(t)
    binding.pry
  end

  #method to make cook_time readable
end
