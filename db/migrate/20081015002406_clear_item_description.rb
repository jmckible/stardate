class ClearItemDescription < ActiveRecord::Migration
  def self.up
    Item.update_all "description = null"
  end

  def self.down
  end
end
