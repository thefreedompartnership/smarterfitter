class WidenConsumedPortionsQuantityField < ActiveRecord::Migration
  def self.up
    change_column :consumed_portions, :quantity, :decimal, :precision => 8, :scale => 3
    ConsumedPortion.update_all "quantity = 100", "quantity = 99.999"
  end

  def self.down
    Weight.update_all "quantity = 99.999", "quantity > 99.999"
    change_column :consumed_portions, :quantity, :decimal, :precision => 5, :scale => 3
  end
end
