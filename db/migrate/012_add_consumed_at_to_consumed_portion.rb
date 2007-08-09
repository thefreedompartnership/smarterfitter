class AddConsumedAtToConsumedPortion < ActiveRecord::Migration
  def self.up
    add_column :consumed_portions, :consumed_at, :datetime
    ConsumedPortion.update_all("consumed_at = created_at")
  end

  def self.down
    remove_column :consumed_portions, :consumed_at
  end
end
