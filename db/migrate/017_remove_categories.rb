class RemoveCategories < ActiveRecord::Migration
  def self.up
    drop_table :categories
  end

  def self.down
    create_table "categories", :force => true do |t|
      t.string  "name"
      t.integer "user_id"
    end

    add_index "categories", ["user_id"], :name => "index_categories_on_user_id"
  end
end
