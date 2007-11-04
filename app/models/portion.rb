class Portion < ActiveRecord::Base

  validates_presence_of :quantity
  
  def energy
    nutrient(Nutrient::ENERGY)
  end

  def fat
    nutrient(Nutrient::FAT)
  end

  def saturated_fat
    nutrient(Nutrient::SATURATED_FAT)
  end

  def carbohydrate
    nutrient(Nutrient::CARBOHYDRATE)
  end

  def protein
    nutrient(Nutrient::PROTEIN)
  end
end
