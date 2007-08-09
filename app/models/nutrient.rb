class Nutrient < ActiveRecord::Base
  has_many  :food_nutrients
  
  PROTEIN = "203"
  ENERGY = "208"
  CARBOHYDRATE = "205"
  FAT = "204"
  SATURATED_FAT = "606"
  
end
