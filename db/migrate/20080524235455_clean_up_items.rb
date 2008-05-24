class CleanUpItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :category_id
    change_column :items, :value, :integer, :null=>false, :default=>0
  end

  def self.down
  end
end
