class AddTypeColumnToPortionsForSti < ActiveRecord::Migration
  def self.up
    add_column :portions, :type, :string
  end

  def self.down
    remove_column :portions, :type
  end
end
