class AddConsumedAtColumnToPortions < ActiveRecord::Migration
  def self.up
    add_column :portions, :consumed_at, :datetime
  end

  def self.down
    remove_column :portions, :consumed_at
  end
end
