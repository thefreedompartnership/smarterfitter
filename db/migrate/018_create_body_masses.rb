class CreateBodyMasses < ActiveRecord::Migration
  def self.up
    create_table :body_masses do |t|
      t.column :mass, :decimal, :precision => 6, :scale => 2
      t.column :recorded_at, :datetime
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :body_masses
  end
end
