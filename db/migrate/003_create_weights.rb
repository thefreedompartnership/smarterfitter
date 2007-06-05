class CreateWeights < ActiveRecord::Migration
  def self.up
    create_table :weights do |t|
      t.column :ndb_number, :string
      t.column :sequence, :integer
      t.column :amount, :decimal, :precision => 5, :scale => 3
      t.column :measure_description, :string
      t.column :weight_in_grams, :decimal, :precision => 7, :scale => 1
      t.column :number_of_data_points, :integer
      t.column :standard_deviation, :decimal, :precision => 7, :scale => 3
      t.column :food_id, :integer
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
    end
  end

  def self.down
    drop_table :weights
  end
end
