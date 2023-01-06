class CreateWeights < ActiveRecord::Migration
  def self.up
    create_table :weights do |t|
      t.integer :user_id
      t.date    :date
      t.decimal :weight,   :precision=>4, :scale=>1
      t.decimal :body_fat, :precision=>4, :scale=>1
      t.timestamps
    end
    
    add_index :weights, :user_id
    add_index :weights, :date
  end

  def self.down
    drop_table :weights
  end
end
