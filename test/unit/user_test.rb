require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :consumed_portions

  def test_portions_for_today
    assert_equal 3, users(:tim).portions_for_today.size
  end
  
  def test_portions_for_today_test
    assert users(:tim).portions_for_today?, "Tim should have portions of food assigned to him for today but did not"
    assert !users(:monica).portions_for_today?, "Monica should not have portions of food assigned to her today but did"
    assert !users(:alice).portions_for_today?, "Alice does not have portions of food assigned to her today but this method is wrong, she has food from the past but not today"
  end
end
