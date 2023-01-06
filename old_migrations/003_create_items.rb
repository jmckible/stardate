class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.column :user_id, :integer
      t.column :category_id, :integer
      t.column :date, :date
      t.column :value, :integer
      t.column :description, :text
    end
    add_index :items, :user_id
    add_index :items, :date
  end

  def self.down
    drop_table :items
  end
end
