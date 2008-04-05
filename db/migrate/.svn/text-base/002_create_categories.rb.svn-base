class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string
      t.column :user_id, :integer
    end
    add_index :categories, :user_id
  end

  def self.down
    drop_table :categories
  end
end
