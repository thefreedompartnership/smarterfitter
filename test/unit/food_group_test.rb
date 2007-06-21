require File.dirname(__FILE__) + '/../test_helper'

class FoodGroupTest < Test::Unit::TestCase
  fixtures :food_groups

  def setup
    @food_group = FoodGroup.find(:first)
  end

  def test_fixture
    assert_equal food_groups(:dairy_and_egg_products).description, @food_group.description
  end
end
