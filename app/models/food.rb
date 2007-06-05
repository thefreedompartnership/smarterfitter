class Food < ActiveRecord::Base
  belongs_to  :food_group
  has_many    :weights
  has_many    :food_nutrients

  def energy
    nutrient('208')
  end

  def protein
    nutrient('203')
  end
  
  def carbohydrate
    nutrient('205')
  end
  
  def fat
    nutrient('204')
  end
  
  def nutrient(nutrient_number)
    food_nutrients.find(:all, :conditions => ['nutrient_number = :nutrient_number', {:nutrient_number => nutrient_number}])[0]
  end
  

end
