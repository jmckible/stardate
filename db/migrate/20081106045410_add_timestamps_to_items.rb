class AddTimestampsToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :created_at, :datetime
    add_column :items, :updated_at, :datetime
    
    Item.reset_column_information
    
    Item.all.each{ |i| i.update_attribute :created_at, i.date.to_time }
    
  end

  def self.down
    remove_column :items, :created_at
    remove_column :items, :updated_at
  end
end
