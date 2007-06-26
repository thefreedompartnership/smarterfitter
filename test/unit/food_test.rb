require File.dirname(__FILE__) + '/../test_helper'

class FoodTest < Test::Unit::TestCase

  fixtures :foods, :weights
  
  def setup
    @food = Food.find(:first)
  end
  
  def test_weights
    assert_equal 4, Food.find(:first).weights.count
  end
  
  def test_can_use_self
    assert_kind_of Food, @food
    assert_equal foods(:butter).long_description, @food.wibble
  end
  
  

end
