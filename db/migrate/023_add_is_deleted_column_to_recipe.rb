class AddIsDeletedColumnToRecipe < ActiveRecord::Migration
  def self.up
    add_column :recipes, :is_deleted, :boolean, :default => 0
  end

  def self.down
    remove_column :recipes, :is_deleted
  end
end
