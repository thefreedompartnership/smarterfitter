class WidenWeightsAmountField < ActiveRecord::Migration
  def self.up
    change_column :weights, :amount, :decimal, :precision => 8, :scale => 3
    Weight.update_all "amount = 100", "sequence = 0"
  end

  def self.down
    Weight.update_all "amount = 99.999", "sequence = 0"
    change_column :weights, :amount, :decimal, :precision => 5, :scale => 3
  end
end
