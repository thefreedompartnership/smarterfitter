class UpdateKeysForChainsToUtc < ActiveRecord::Migration
  def self.up
    Chain.update_all('time_zone = "UTC"')
  end

  def self.down
    Chain.update_all('time_zone = null')
  end
end
