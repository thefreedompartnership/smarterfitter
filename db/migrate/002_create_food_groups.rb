class CreateFoodGroups < ActiveRecord::Migration
  def self.up
    create_table :food_groups do |t|
      t.column :code, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :food_groups
  end
end
