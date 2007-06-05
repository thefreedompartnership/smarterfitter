class AddIndexToNutrientsAndFoods < ActiveRecord::Migration
  def self.up
    add_index :foods, :ndb_number
    add_index :nutrients, :nutrient_number
  end

  def self.down
    remove_index :foods, :ndb_number
    remove_index :nutrients, :nutrient_number
  end
end
