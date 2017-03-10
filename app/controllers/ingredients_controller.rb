class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :destroy, :show]

  def index
    logged_in_yield do
      if Ingredient.all.empty?
        redirect_to :back, alert: "sorry, no ingredients to see yet"
      else
        @ingredients = Ingredient.all
      end
    end
  end

  def new #admin only #yield?
    if current_user && current_user.admin?
      @ingredient = Ingredient.new
    else
      redirect_to :back, alert: "not authorized to perform this action" #can encapsulate this alert message in a method
    end
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      redirect_to ingredient_path(@ingredient)
    else
      render :new
    end
  end

  def show #yield?
    logged_in_yield do
      render :show
    end
  end

  def edit #yield?
    if logged_in? && current_user && current_user.admin? #yield
      render :edit
    else
      redirect_to :back, alert: "not authorized to perform this action" #can encapsulate this alert message in a method
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to ingredient_path(@ingredient)
    else
      render :edit
    end
  end

  def destroy #yield?
    if @ingredient && current_user && current_user.admin?
      @ingredient.destroy
      redirect_to :back
    else
      redirect_to :back, alert: "ingredient couldn't be found"
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :allergen_warning, :spice_level, :ingredient_type)
  end

  def set_ingredient
    @ingredient = Ingredient.find_by(id: params[:id])
  end

  #do you need strong params if ingredients are created in the Recipe model from the recipe controller?
end
