class FoodGroup < ActiveRecord::Base
  has_many  :foods
end
