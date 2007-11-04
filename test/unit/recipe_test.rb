require File.dirname(__FILE__) + '/../test_helper'

class RecipeTest < Test::Unit::TestCase
  fixtures :recipes, :users, :weights, :foods, :food_nutrients, :nutrients
  
  def setup
    @recipe = Recipe.new
  end
  
  def valid_attributes
    { :servings => 3, :description => "my first recipe", :instructions => "add ingredients, stir well", :user => users(:tim) }
  end
  
  def test_valid_recipe
    @recipe = Recipe.new(valid_attributes)
    assert @recipe.valid?
  end
  
  def test_should_require_servings
    @recipe.attributes = valid_attributes.except(:servings)
    assert !@recipe.valid?
    @recipe.servings = "foo"
    assert !@recipe.valid?
    assert @recipe.errors.invalid?(:servings)
  end
  
  def test_should_require_description
    @recipe.attributes = valid_attributes.except(:description)
    assert !@recipe.valid?
    assert @recipe.errors.invalid?(:description)
    long_description = ""
    260.times {  long_description += "words " }
    @recipe.description = long_description
    assert !@recipe.valid?
    assert @recipe.errors.invalid?(:description)
  end
  
  def test_nutrient
    @recipe.attributes = valid_attributes
    one_hundred_grams_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    assert_equal 717, one_hundred_grams_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 717 but wasn't" 
    
    one_and_a_half_cups_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))
    assert_equal 2441.385, one_and_a_half_cups_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 2441.385 but wasn't"

    @recipe.ingredient_portions << one_hundred_grams_of_butter
    @recipe.ingredient_portions << one_and_a_half_cups_of_butter

    total_energy = one_and_a_half_cups_of_butter.nutrient(Nutrient::ENERGY) + 
                   one_hundred_grams_of_butter.nutrient(Nutrient::ENERGY)
    assert_equal total_energy, @recipe.nutrient(Nutrient::ENERGY)    
  end

  def test_nutrient_per_serving
    @recipe.attributes = valid_attributes
    one_hundred_grams_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    assert_equal 717, one_hundred_grams_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 717 but wasn't" 
    
    one_and_a_half_cups_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))
    assert_equal 2441.385, one_and_a_half_cups_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 2441.385 but wasn't"

    @recipe.ingredient_portions << one_hundred_grams_of_butter
    @recipe.ingredient_portions << one_and_a_half_cups_of_butter

    total_energy = one_and_a_half_cups_of_butter.nutrient(Nutrient::ENERGY) + 
                   one_hundred_grams_of_butter.nutrient(Nutrient::ENERGY)
    assert_equal total_energy / @recipe.servings, @recipe.nutrient_per_serving(Nutrient::ENERGY)    
  end

  def test_should_delete_record_if_no_recipe_portions
    @recipe.attributes = valid_attributes
    @recipe.save!
    recipe_id = @recipe.id
    @recipe.destroy
    Recipe.find(recipe_id)
    fail
  rescue ActiveRecord::RecordNotFound
    #exception thrown as expected
  end

  def test_should_not_delete_record_if_recipe_portions
    @recipe.attributes = valid_attributes
    @recipe.save
    recipe_id = @recipe.id
    @recipe.recipe_portions << RecipePortion.new(:quantity => 1, :user => users(:tim))
    @recipe.save
    @recipe.destroy
    assert Recipe.find(recipe_id).is_deleted?
  end

  def test_should_not_find_soft_deleted_recipes
    @recipe.attributes = valid_attributes
    @recipe.recipe_portions << RecipePortion.new(:quantity => 1, :user => users(:tim))
    @recipe.save!
    @recipe.destroy
    assert_equal 2, users(:tim).recipes.size
  end
  
  def test_should_delete_children_on_destroy
    @recipe.attributes = valid_attributes
    one_hundred_grams_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    @recipe.ingredient_portions << one_hundred_grams_of_butter
    @recipe.save!
    ingredient_id = @recipe.ingredient_portions[0].id
    @recipe.destroy
    IngredientPortion.find(ingredient_id)
    fail "this ingredient should have been deleted and never found!"
  rescue ActiveRecord::RecordNotFound
    #expected to be thrown because ingredients were deleted
  end

end
