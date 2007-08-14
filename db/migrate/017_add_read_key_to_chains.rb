class AddReadKeyToChains < ActiveRecord::Migration
  def self.up
    add_column :chains, :read_key, :string
    add_index :chains, [:read_key], :unique => true
    Chain.update_all('read_key = sha1(concat(name, created_at, rand()))')
  end

  def self.down
    remove_column :chains, :read_key
  end
end
