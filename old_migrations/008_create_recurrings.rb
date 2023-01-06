class CreateRecurrings < ActiveRecord::Migration
  def self.up
    create_table :recurrings do |t|
      t.column :user_id, :integer
      t.column :category_id, :integer
      t.column :day, :integer
      t.column :value, :integer
      t.column :description, :text
    end
    add_index :recurrings, :user_id
    add_index :recurrings, :day
  end

  def self.down
    drop_table :recurrings
  end
end
