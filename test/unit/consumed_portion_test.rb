require File.dirname(__FILE__) + '/../test_helper'

class ConsumedPortionTest < Test::Unit::TestCase
  fixtures :consumed_portions, :foods, :food_nutrients, :weights

  def test_description
    assert_equal "100 grams Butter, salted", consumed_portions(:one_hundred_grams_of_butter).description
    assert_equal "1.5 cup Butter, salted", consumed_portions(:one_and_a_half_cups_of_butter).description
  end
  
  def test_format_number
    assert_equal "2", ConsumedPortion.format_number(BigDecimal.new("2.00"))
    assert_equal "2.5", ConsumedPortion.format_number(BigDecimal.new("2.50"))
    assert_equal "13.5", ConsumedPortion.format_number(BigDecimal.new("13.5"))
    assert_equal "13", ConsumedPortion.format_number(BigDecimal.new("13"))
  end
  
  def test_fat_calculation
    assert_in_delta 81.11, consumed_portions(:one_hundred_grams_of_butter).fat, 0.001
    assert_in_delta 276.18, consumed_portions(:one_and_a_half_cups_of_butter).fat, 0.000001
  end
  def test_carbohydrate_calculation
    assert_in_delta 0.06, consumed_portions(:one_hundred_grams_of_butter).carbohydrate, 0.001
    assert_in_delta 0.204, consumed_portions(:one_and_a_half_cups_of_butter).carbohydrate, 0.00001
  end
  def test_protein_calculation
    assert_in_delta 0.85, consumed_portions(:one_hundred_grams_of_butter).protein, 0.001
    assert_in_delta 2.894, consumed_portions(:one_and_a_half_cups_of_butter).protein, 0.000001
  end
  def test_energy_calculaton
    assert_in_delta 717.0, consumed_portions(:one_hundred_grams_of_butter).energy, 0.01
    assert_in_delta 2441.385, consumed_portions(:one_and_a_half_cups_of_butter).energy, 0.0001
  end
  def test_saturated_fat_calculaton
    assert_in_delta 51.368, consumed_portions(:one_hundred_grams_of_butter).saturated_fat, 0.01
    assert_in_delta 174.908, consumed_portions(:one_and_a_half_cups_of_butter).saturated_fat, 0.0001
  end

  
  def test_food_and_weight_only_constructor
    food = foods("butter")
    weight = food.weights[1]
    portion = ConsumedPortion.new(:food => food, :weight => weight, :quantity => 1.5)
    assert_equal consumed_portions(:one_and_a_half_cups_of_butter).description, portion.description
    portion = ConsumedPortion.new(:food => foods(:butter), :weight => foods(:butter).weights[0], :quantity => 100)
    assert_equal consumed_portions(:one_hundred_grams_of_butter).description, portion.description
  end

  def test_rounding_works_okay
    portion = ConsumedPortion.new(:food => foods(:butter), :weight => foods(:butter).weights[3], :quantity => 1)
    assert_equal "1 cup Butter, salted", portion.description
  end
end
