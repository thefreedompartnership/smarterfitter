class CreateConsumedPortions < ActiveRecord::Migration
  def self.up
    create_table :consumed_portions do |t|
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
      t.column :quantity, :decimal, :precision => 5, :scale => 3
      t.column :weight_id, :integer
      t.column :food_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :consumed_portions
  end
end
