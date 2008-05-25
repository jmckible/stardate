class PaycheckItemCanBeNull < ActiveRecord::Migration
  def self.up
    change_column :paychecks, :item_id, :integer, :null=>true
  end

  def self.down
  end
end
