class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.column :when, :date
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :chain_id, :integer
    end
    add_index :days, :when
  end

  def self.down
    drop_table :days
  end
end
