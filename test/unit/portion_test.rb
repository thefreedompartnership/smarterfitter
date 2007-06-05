require File.dirname(__FILE__) + '/../test_helper'

class PortionTest < Test::Unit::TestCase
  fixtures :foods
  fixtures :weights
  fixtures :food_nutrients
  fixtures :nutrients
  
  def test_portion_energy
    butter = Food.find(:first)
    assert_equal "01001", butter.ndb_number
    assert_equal "cup", butter.weights[0].measure_description
    portion = Portion.new(butter, butter.weights[0], 1)
    assert_in_delta 1627.59, portion.energy, 0.001
  end
  
  def test_default_quantity
    butter = Food.find(:first)
    portion = Portion.new(butter, butter.weights[0])    
    assert_equal 1, portion.quantity
    portion = Portion.new(butter, butter.weights[0], 6)    
    assert_equal 6, portion.quantity
    portion = Portion.new(butter, butter.weights[1])    
    assert_equal 2, portion.quantity
  end
end
