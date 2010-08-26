class CreateEllipticals < ActiveRecord::Migration
  def self.up
    create_table :ellipticals do |t|
      t.date :date
      t.decimal :distance, :precision=>10, :scale=>2
      t.integer :user_id, :minutes
      t.timestamps
    end
    add_index :ellipticals, :user_id
  end

  def self.down
    drop_table :ellipticals
  end
end
