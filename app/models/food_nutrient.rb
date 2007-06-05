class FoodNutrient < ActiveRecord::Base
  belongs_to  :food
  belongs_to  :nutrient
end
