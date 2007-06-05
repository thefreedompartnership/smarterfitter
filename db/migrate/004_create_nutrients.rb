class CreateNutrients < ActiveRecord::Migration
  def self.up
    create_table :nutrients do |t|
      t.column :nutrient_number, :string
      t.column :units, :string
      t.column :infoods_tagname, :string
      t.column :nutrient_description, :string
      t.column :decimal_places_rounded_to, :integer
      t.column :sort_order, :integer
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
    end
  end

  def self.down
    drop_table :nutrients
  end
end
