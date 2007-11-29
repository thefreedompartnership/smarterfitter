require File.dirname(__FILE__) + '/../test_helper'

class PortionTest < Test::Unit::TestCase
  fixtures :portions, :users, :weights, :foods, :food_nutrients, :nutrients, :food_groups

  def test_description
    assert_equal "100 grams Butter, salted", portions(:one_hundred_grams_of_butter).description
    assert_equal "1.5 cup Butter, salted", portions(:one_and_a_half_cups_of_butter).description
  end
  
  def test_format_number
    assert_equal "2", WeightPortion.format_number(BigDecimal.new("2.00"))
    assert_equal "2.5", WeightPortion.format_number(BigDecimal.new("2.50"))
    assert_equal "13.5", WeightPortion.format_number(BigDecimal.new("13.5"))
    assert_equal "13", WeightPortion.format_number(BigDecimal.new("13"))
  end
  
  def test_fat_calculation
    assert_in_delta 81.11, portions(:one_hundred_grams_of_butter).fat, 0.001
    assert_in_delta 276.18, portions(:one_and_a_half_cups_of_butter).fat, 0.001
  end
  def test_carbohydrate_calculation
    assert_in_delta 0.06, portions(:one_hundred_grams_of_butter).carbohydrate, 0.001
    assert_in_delta 0.204, portions(:one_and_a_half_cups_of_butter).carbohydrate, 0.001
  end
  def test_protein_calculation
    assert_in_delta 0.85, portions(:one_hundred_grams_of_butter).protein, 0.001
    assert_in_delta 2.894, portions(:one_and_a_half_cups_of_butter).protein, 0.001
  end
  def test_energy_calculaton
    assert_in_delta 717.0, portions(:one_hundred_grams_of_butter).energy, 0.01
    assert_in_delta 2441.385, portions(:one_and_a_half_cups_of_butter).energy, 0.001
  end
  def test_saturated_fat_calculaton
    assert_in_delta 51.368, portions(:one_hundred_grams_of_butter).saturated_fat, 0.01
    assert_in_delta 174.908, portions(:one_and_a_half_cups_of_butter).saturated_fat, 0.001
  end
  def test_nil_saturated_fat_calculation_is_handled
    assert_equal 0, portions(:charlies_chard).saturated_fat
  end

  
  def test_weight_only_constructor
    food = foods("butter")
    weight = food.weights[1]
    portion = WeightPortion.new(:weight => weight, :quantity => 1.5)
    assert_equal portions(:one_and_a_half_cups_of_butter).description, portion.description
    portion = WeightPortion.new(:weight => foods(:butter).weights[0], :quantity => 100)
    assert_equal portions(:one_hundred_grams_of_butter).description, portion.description
  end

  def test_rounding_works_okay
    portion = WeightPortion.new(:weight => foods(:butter).weights[3], :quantity => 1)
    assert_equal "1 cup Butter, salted", portion.description
  end

#from here are the new tests

  def test_energy
    one_hundred_grams_of_butter = WeightPortion.new(:user => users(:tim), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    assert_equal 717, one_hundred_grams_of_butter.energy, "energy in 100g of butter should be 717 but wasn't" 
    
    one_and_a_half_cups_of_butter = WeightPortion.new(:user => users(:tim), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))
    assert_equal 2441.385, one_and_a_half_cups_of_butter.energy, "energy in 100g of butter should be 2441.385 but wasn't"
  end

  def test_nutrient
    one_hundred_grams_of_butter = WeightPortion.new(:user => users(:tim), 
                                    :weight => weights(:one_hundred_grams_of_butter), 
                                    :quantity => BigDecimal.new("100"))
    assert_equal 717, one_hundred_grams_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 717 but wasn't" 
    
    one_and_a_half_cups_of_butter = WeightPortion.new(:user => users(:tim), 
                                      :weight => weights(:cup_of_butter), 
                                      :quantity => BigDecimal.new("1.5"))
    assert_equal 2441.385, one_and_a_half_cups_of_butter.nutrient(Nutrient::ENERGY), "energy in 100g of butter should be 2441.385 but wasn't"
  end

end
