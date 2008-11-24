class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.date    :date
      t.decimal :distance, :precision=>10, :scale=>2
      t.integer :user_id
      t.timestamps
    end
    
    add_index :runs, :user_id
  end

  def self.down
    drop_table :runs
  end
end
