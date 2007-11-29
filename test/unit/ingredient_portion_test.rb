require File.dirname(__FILE__) + '/../test_helper'

class IngredientPortionTest < Test::Unit::TestCase
  fixtures :portions, :recipes, :weights, :foods, :food_nutrients, :nutrients, :food_groups


  def test_energy
    one_hundred_grams_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    assert_equal 717, one_hundred_grams_of_butter.energy, "energy in 100g of butter should be 717 but wasn't" 
    
    one_and_a_half_cups_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))
    assert_equal 2441.385, one_and_a_half_cups_of_butter.energy, "energy in 100g of butter should be 2441.385 but wasn't"
  end

  def test_nutrient
    one_hundred_grams_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    assert_equal 717, one_hundred_grams_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 717 but wasn't" 
    
    one_and_a_half_cups_of_butter = IngredientPortion.new(:recipe => recipes(:one), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))
    assert_equal 2441.385, one_and_a_half_cups_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 2441.385 but wasn't"
  end

end
