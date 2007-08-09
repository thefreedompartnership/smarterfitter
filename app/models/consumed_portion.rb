class ConsumedPortion < ActiveRecord::Base
  belongs_to :food
  belongs_to :weight
  belongs_to :user

  def description
    "#{ConsumedPortion.format_number(portion.quantity)} #{portion.weight.measure_description} #{portion.food.long_description}" 
  end
  
  def fat
    self.portion.fat
  end

  def energy
    self.portion.energy
  end

  def carbohydrate
    self.portion.carbohydrate
  end

  def protein
    self.portion.protein
  end
  
  def saturated_fat
    fat = self.portion.nutrient(Nutrient::SATURATED_FAT)
    if fat.nil?
      return BigDecimal.new("0")
    else
      return fat
    end
  end

  def nutrient(nutrient_number)
    self.portion.nutrient(nutrient_number)
  end

  def portion
    if attributes["quantity"].nil?
      portion = Portion.new(self.food, self.weight)
    else
      portion = Portion.new(self.food, self.weight, self.quantity)
    end
    return portion
  end
  
  private
  def self.format_number(f)
    if f % 1 != 0
      return f.to_s
    else
      return sprintf("%d", f)
    end
  end
  
end
