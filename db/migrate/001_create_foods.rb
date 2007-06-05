class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.column :ndb_number, :string
      t.column :food_group_code, :string
      t.column :long_description, :string
      t.column :short_description, :string
      t.column :common_name, :string
      t.column :manufacturer_name, :string
      t.column :survey, :string
      t.column :refuse_description, :string
      t.column :refuse_percentage, :integer
      t.column :scientific_name, :string
      t.column :nitrogen_factor, :decimal, :precision => 4, :scale => 2
      t.column :protein_factor, :decimal, :precision => 4, :scale => 2
      t.column :fat_factor, :decimal, :precision => 4, :scale => 2
      t.column :cho_factor, :decimal, :precision => 4, :scale => 2
      t.column :food_group_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :foods
  end
end
