require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :portions, :weights, :foods, :food_nutrients, :nutrients

  def test_portions_for_today
    assert_equal 3, users(:tim).portions_for(Date.today).length
  end
  
  def test_portions_for_today_test
    assert users(:tim).portions_for?(Date.today), "Tim should have portions of food assigned to him for today but did not"
    assert !users(:monica).portions_for?(Date.today), "Monica should not have portions of food assigned to her today but did"
    assert !users(:alice).portions_for?(Date.today), "Alice does not have portions of food assigned to her today but this method is wrong, she has food from the past but not today"
  end
  
  def test_nutrient_averages
    assert_equal 35, users(:bob).user_portions.count
    assert_equal BigDecimal.new("1.9295"), users(:bob).protein_for(Date.today)
    assert_equal BigDecimal.new("1.9295"), users(:bob).protein_for(Date.today - 1)
    assert_equal BigDecimal.new("2"), users(:bob).average_protein_last_seven_days
    assert_equal BigDecimal.new("2"), users(:bob).average_protein_last_thirty_days
    assert_equal BigDecimal.new("1628"), users(:bob).average_energy_last_thirty_days
    assert_equal BigDecimal.new("2"), users(:bob).average_protein
  end
  
  def test_nutrient_percentages_of_calories
    assert_equal ((users(:bob).protein_for(Date.today) * 4) / users(:bob).energy_for(Date.today)) * 100, users(:bob).percent_calories_from_protein_for(Date.today)
    assert_equal ((users(:bob).fat_for(Date.today) * 9) / users(:bob).energy_for(Date.today)) * 100, users(:bob).percent_calories_from_fat_for(Date.today)
    assert_equal ((users(:bob).saturated_fat_for(Date.today) * 9) / users(:bob).energy_for(Date.today)) * 100, users(:bob).percent_calories_from_saturated_fat_for(Date.today)
    assert_equal ((users(:bob).carbohydrate_for(Date.today) * 4) / users(:bob).energy_for(Date.today)) * 100, users(:bob).percent_calories_from_carbohydrate_for(Date.today)
  end

  def test_nutrient_percentages_of_calories_when_no_food_does_not_divide_by_zero
    assert_equal 0, users(:monica).percent_calories_from_protein_for(Date.today)
    assert_equal 0, users(:monica).percent_calories_from_fat_for(Date.today)
    assert_equal 0, users(:monica).percent_calories_from_carbohydrate_for(Date.today)
  end
  
  def test_saturated_fat_today
    assert_equal BigDecimal.new("116.60536"), users(:bob).saturated_fat_for(Date.today)
  end
  def test_saturated_fat_today_when_some_food_has_no_saturated_fat
    assert_equal ((users(:charlie).saturated_fat_for(Date.today) * 9) / users(:charlie).energy_for(Date.today)) * 100, users(:charlie).percent_calories_from_saturated_fat_for(Date.today)
  end
end
