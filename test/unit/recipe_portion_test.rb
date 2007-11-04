require File.dirname(__FILE__) + '/../test_helper'

class RecipePortionTest < Test::Unit::TestCase
  fixtures :users, :portions, :recipes, :weights, :foods, :food_nutrients, :nutrients, :food_groups

  def test_nutrient

    recipe = Recipe.new({ :servings => 3, :description => "my first recipe", 
      :instructions => "add ingredients, stir well", :user => users(:tim) })
      
    one_hundred_grams_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    
    one_and_a_half_cups_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))

    recipe.ingredient_portions << one_hundred_grams_of_butter
    recipe.ingredient_portions << one_and_a_half_cups_of_butter

    # 2 servings of this recipe
    recipe_portion = RecipePortion.new(:quantity => 2, :user => users(:tim), :recipe => recipe)
    total_energy = recipe.nutrient(Nutrient::ENERGY)
    assert_equal (2 * total_energy / 3), recipe_portion.nutrient(Nutrient::ENERGY)
  end


end
