class PortionThing

  attr_reader :food, :food_nutrients, :weight, :quantity

  def initialize(food, weight, q=nil)
    @food = food
    @weight = weight
    
    if !q.nil?
      @quantity = q / @weight.amount
    else
      @quantity = BigDecimal.new("1")
    end

    @multiplier = @quantity * (@weight.weight_in_grams / BigDecimal.new("100"))
  end
  
  def quantity
    (@quantity * @weight.amount).round(3)
  end
  
  def energy
    (@food.energy.nutrient_value * @multiplier).round(3)
  end
  
  def fat
    (@food.fat.nutrient_value * @multiplier).round(3)
  end
  
  def carbohydrate
    (@food.carbohydrate.nutrient_value * @multiplier).round(3)
  end
  
  def protein
    (@food.protein.nutrient_value * @multiplier).round(3)
  end

  def nutrient(nutrient_number)
    n = @food.nutrient(nutrient_number)
    if(n)
      (@food.nutrient(nutrient_number).nutrient_value * @multiplier).round(3)
    else
      BigDecimal.new("0")
    end
  end
  
  def to_chart_data
    chart_data = {}
    chart_data["Fat"] = fat
    chart_data["Protein"] = protein
    chart_data["Carbs"] = carbohydrate
    chart_data["Other"] = quantity - (carbohydrate + protein + fat)
    chart_data
  end
  
end