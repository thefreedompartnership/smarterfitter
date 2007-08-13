class AddTimeZoneToChain < ActiveRecord::Migration
  def self.up
    add_column :chains, :time_zone, :string
  end

  def self.down
    remove_column :chains, :time_zone
  end
end
