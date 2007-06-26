class Weight < ActiveRecord::Base
  belongs_to  :food
  
  def Weight.one_hundred_grams
    @@one_hundred_grams
  end
  
  @@one_hundred_grams = Weight.new(:id => 0, 
                                    :sequence => 0, 
                                    :weight_in_grams => 100.0, 
                                    :measure_description => 'grams',
                                    :number_of_data_points => 0,
                                    :amount => 100,
                                    :ndb_number => nil,
                                    :standard_deviation => 0.0,
                                    :food_id => nil)

end
