class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :body
      t.date :date
      t.integer :user_id
      t.timestamps
    end
    add_index :notes, :user_id
  end

  def self.down
    drop_table :notes
  end
end
