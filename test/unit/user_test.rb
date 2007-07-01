require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :consumed_portions, :weights, :foods, :food_nutrients, :nutrients

  def test_portions_for_today
    assert_equal 3, users(:tim).portions_for_today.size
  end
  
  def test_portions_for_today_test
    assert users(:tim).portions_for_today?, "Tim should have portions of food assigned to him for today but did not"
    assert !users(:monica).portions_for_today?, "Monica should not have portions of food assigned to her today but did"
    assert !users(:alice).portions_for_today?, "Alice does not have portions of food assigned to her today but this method is wrong, she has food from the past but not today"
  end
  
  def test_nutrient_averages
    assert_equal 35, users(:bob).consumed_portions.count
    assert_equal BigDecimal.new("1.93"), users(:bob).protein_today
    assert_equal BigDecimal.new("1.93"), users(:bob).protein_yesterday
    assert_equal BigDecimal.new("1.93"), users(:bob).average_protein_last_seven_days
    assert_equal BigDecimal.new("1.93"), users(:bob).average_protein_last_thirty_days
    assert_equal BigDecimal.new("1627.59"), users(:bob).average_energy_last_thirty_days
    assert_equal BigDecimal.new("1.93"), users(:bob).average_protein
  end
end
