class AddAmortizationToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :start,    :date
    add_column :items, :end,      :date
    add_column :items, :per_diem ,:integer
    
    add_index :items, :start
    add_index :items, :end
    
    Item.update_all "start = date, end = date, per_diem = value"
  end

  def self.down
    remove_column :items, :start
    remove_column :items, :end
    remove_column :items, :per_diem
  end
end
