class RemovePaycheckPaid < ActiveRecord::Migration
  def self.up
    remove_column :paychecks, :paid
  end

  def self.down
    add_column :paychecks, :paid, :boolean
  end
end
