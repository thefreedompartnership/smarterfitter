class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.column :servings, :integer
      t.column :description, :string
      t.column :instructions, :text
      t.column :created_at, :datetime
      t.column :modified_at, :datetime
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :recipes
  end
end
