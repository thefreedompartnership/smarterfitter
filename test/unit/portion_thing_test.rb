require File.dirname(__FILE__) + '/../test_helper'

class PortionThingTest < Test::Unit::TestCase
  
  fixtures :foods, :nutrients, :food_nutrients, :weights
  
  def test_portion_energy
    butter = Food.find(:first)
    assert_equal "01001", butter.ndb_number
    assert_equal "cup", butter.weights[1].measure_description
    portion = PortionThing.new(butter, butter.weights[1], 1)
    assert_in_delta 1627.59, portion.energy, 0.001
    
    butter = Food.find(:first)
    assert_equal "01001", butter.ndb_number
    assert_equal "grams", butter.weights[0].measure_description
    portion = PortionThing.new(butter, butter.weights[0], 100)
    assert_in_delta 717, portion.energy, 0.001
  end

  def test_portion_fat
    butter = Food.find(:first)
    assert_equal "01001", butter.ndb_number
    assert_equal "cup", butter.weights[1].measure_description
    portion = PortionThing.new(butter, butter.weights[1], 1)
    assert_in_delta 184.12, portion.fat, 0.00001
  end
  
  def test_portion_rounding
    portion = PortionThing.new(foods(:butter), foods(:butter).weights[3], BigDecimal.new("1"))
    assert_equal BigDecimal.new("673.687"), portion.fat
    assert_equal BigDecimal.new("0.498"), portion.carbohydrate
    assert_equal BigDecimal.new("7.06"), portion.protein
    assert_equal BigDecimal.new("5955.292"), portion.energy
  end

  
  def test_default_quantity
    butter = Food.find(:first)
    
    portion = PortionThing.new(butter, butter.weights[0], 123)
    assert_equal 123, portion.quantity
                                         
    portion = PortionThing.new(butter, butter.weights[0])
    assert_equal 100, portion.quantity
                                         
    portion = PortionThing.new(butter, butter.weights[0], 600)    
    assert_equal 600, portion.quantity
                                         
    portion = PortionThing.new(butter, butter.weights[1])    
    assert_equal 1, portion.quantity     
                                         
    portion = PortionThing.new(butter, butter.weights[1], 2)    
    assert_equal 2, portion.quantity
  end
  
  def test_rounding_of_quantity
    portion = PortionThing.new(foods(:butter), foods(:butter).weights[3], BigDecimal.new("1"))
    assert_equal BigDecimal.new("1"), portion.quantity
  end
  
  
end
