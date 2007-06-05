class Portion

  attr_reader :food, :weight, :quantity

  def initialize(food, weight, quantity=weight.amount)
    @food = food
    @weight = weight
    @quantity = quantity

    @multiplier = @quantity * (@weight.weight_in_grams / 100.0)
  end
  
  def energy
    @food.energy.nutrient_value * @multiplier
  end
  def fat
    @food.fat.nutrient_value.to_f * @multiplier
  end
  def carbohydrate
    @food.carbohydrate.nutrient_value.to_f * @multiplier
  end
  def protein
    @food.protein.nutrient_value.to_f * @multiplier
  end
  def nutrient(nutrient_number)
    n = @food.nutrient(nutrient_number)
    if(n)
      @food.nutrient(nutrient_number).nutrient_value.to_f * @multiplier
    else
      nil
    end
  end
end