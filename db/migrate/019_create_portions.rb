class CreatePortions < ActiveRecord::Migration
  def self.up
    create_table :portions do |t|
      t.column :quantity, :decimal, :precision => 5, :scale => 3
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
      t.column :user_id, :integer
      t.column :recipe_id, :integer
      t.column :weight_id, :integer
    end
  end

  def self.down
    drop_table :portions
  end
end
