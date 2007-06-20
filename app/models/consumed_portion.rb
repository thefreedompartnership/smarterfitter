class ConsumedPortion < ActiveRecord::Base
  belongs_to :food
  belongs_to :weight
  belongs_to :user

  def portion
    w = self.weight
    w = Weight.one_hundred_grams if w.nil?
    @portion = Portion.new(self.food, w, attributes["quantity"]) if @portion.nil?
    return @portion
  end
end
