class RecipePortion < UserPortion
  belongs_to :recipe
  
  def nutrient(nutrient_number)
    self.quantity * recipe.nutrient_per_serving(nutrient_number)
  end
end