class CreateChains < ActiveRecord::Migration
  def self.up
    create_table :chains do |t|
      t.column :name, :string
      t.column :key, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_index :chains, [:key], :unique => true
  end

  def self.down
    drop_table :chains
  end
end
