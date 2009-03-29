class AddAmortizationToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :start,    :date
    add_column :items, :finish,   :date
    add_column :items, :per_diem ,:integer
    
    add_index :items, :start
    add_index :items, :finish
    
    Item.update_all "start = date, finish = date, per_diem = value"
  end

  def self.down
    remove_column :items, :start
    remove_column :items, :finish
    remove_column :items, :per_diem
  end
end
