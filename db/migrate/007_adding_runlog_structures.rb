class AddingRunlogStructures < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.column :user_id, :integer
      t.column :when_run, :datetime
      t.column :distance_in_meters, :integer
      t.column :distance_unit, :string
      t.column :duration_in_seconds, :integer
      t.column :route, :string
      t.column :description, :text
      t.column :route_points, :text
    end
    
    create_table :users do |t|
      t.column :user_name, :string
      t.column :email_address, :string
      t.column :hashed_password, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :measurement_system, :string
      t.column :time_zone, :string
      t.column :default_latitude, :string
      t.column :default_longitude, :string
      t.column :default_zoom, :string
    end
  end

  def self.down
    drop_table :runs
    drop_table :users
  end
end
