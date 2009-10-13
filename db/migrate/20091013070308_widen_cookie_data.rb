class WidenCookieData < ActiveRecord::Migration
  def self.up
      execute "ALTER TABLE sessions CHANGE COLUMN data data LONGTEXT"
  end

  def self.down
  end
end
