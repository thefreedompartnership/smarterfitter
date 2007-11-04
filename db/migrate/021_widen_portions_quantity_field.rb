class WidenPortionsQuantityField < ActiveRecord::Migration
  def self.up
    change_column :portions, :quantity, :decimal, :precision => 8, :scale => 3
  end

  def self.down
    change_column :portions, :quantity, :decimal, :precision => 5, :scale => 3
  end
end
