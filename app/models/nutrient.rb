class Nutrient < ActiveRecord::Base
  has_many  :food_nutrients
end
