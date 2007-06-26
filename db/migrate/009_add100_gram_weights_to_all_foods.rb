class Add100GramWeightsToAllFoods < ActiveRecord::Migration
  def self.up
    Food.find(:all).each do |f| 
      f.weights << Weight.new(:ndb_number => f.ndb_number, 
                              :sequence => 0,
                              :amount => 100,
                              :measure_description => "grams",
                              :weight_in_grams => 100 )
    end
  end

  def self.down
    Weight.delete_all("sequence = 0")
  end
end
