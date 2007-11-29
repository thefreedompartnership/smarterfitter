class RecipePortion < UserPortion
  belongs_to :recipe

  def description
    "#{RecipePortion.format_number(self.quantity)} serving of #{recipe.description}"
  end
    
  def nutrient(nutrient_number)
    self.quantity * recipe.nutrient_per_serving(nutrient_number)
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