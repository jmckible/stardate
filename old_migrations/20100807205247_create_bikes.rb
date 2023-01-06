class CreateBikes < ActiveRecord::Migration
  def self.up
    create_table :bikes do |t|
      t.date :date
      t.decimal :distance, :precision=>10, :scale=>2
      t.integer :user_id, :minutes
      t.timestamps
    end
    add_index :bikes, :user_id
  end

  def self.down
    drop_table :bikes
  end
end