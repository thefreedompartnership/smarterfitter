class CreateLinkSuggestions < ActiveRecord::Migration
  def self.up
    create_table :link_suggestions do |t|
      t.column :name, :string
      t.column :email_address, :string
      t.column :website, :string
      t.column :title, :string
      t.column :link, :string
      t.column :description, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :link_suggestions
  end
end
