class WeightPortion < UserPortion
  belongs_to :weight  
  validates_presence_of :weight
  
  # this gets a little tricky because while the db has "weights" that include amounts we want to
  # use the quantity as the natural amount so 100 grams of butter the 100 is the quantity and we
  # have to account for weight.amount being 100 too.
  # a contrived example
  # weight: 3 cups of butter
  # portion: 6 cups of butter
  # want it to be: 2 * 3 cups of butter
  # so (quantity / weight.amount) * (3 cups of butter).weight_in_grams = (the weight of 6 cups of butter in grams)
  # then find the nutrient value of 100 grams of butter and divide by 100 to get the nutrient value of 1 gram
  # ((self.quantity / @weight.amount) * @weight.weight_in_grams) * (@weight.food.energy.nutrient_value / BigDecimal.new("100"))
  
  # it is sufficient to define nutrient here and then the superclass can call to this to implement
  # all the conveniences
  def nutrient(nutrient_number) 
    ((self.quantity / @weight.amount) * @weight.weight_in_grams) * (@weight.food.nutrient(nutrient_number).nutrient_value / BigDecimal.new("100"))
  end
end