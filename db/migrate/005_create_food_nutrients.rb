class CreateFoodNutrients < ActiveRecord::Migration
  def self.up
    create_table :food_nutrients do |t|
      t.column :ndb_number, :string
      t.column :nutrient_number, :string
      t.column :nutrient_value, :decimal, :precision => 10, :scale => 3
      t.column :number_of_data_points, :integer
      t.column :standard_error, :decimal, :precision => 8, :scale => 3
      t.column :source_code, :string
      t.column :derivation_code, :string
      t.column :reference_ndb_number, :string
      t.column :is_added_nutrient, :string
      t.column :number_of_studies, :integer
      t.column :minimum_value, :decimal, :precision => 10, :scale => 3
      t.column :maximum_value, :decimal, :precision => 10, :scale => 3
      t.column :degrees_of_freedom, :integer
      t.column :lower_error_bound, :decimal, :precision => 10, :scale => 3
      t.column :upper_error_bound, :decimal, :precision => 10, :scale => 3
      t.column :statistical_comments, :string
      t.column :confidence_code, :string
      t.column :food_id, :integer
      t.column :nutrient_id, :integer
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
    end
    add_index :food_nutrients, :food_id
    add_index :food_nutrients, :nutrient_id
    add_index :food_nutrients, :ndb_number
    add_index :food_nutrients, :nutrient_number
  end

  def self.down
    drop_table :food_nutrients
  end
end
