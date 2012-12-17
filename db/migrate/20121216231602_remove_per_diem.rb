class RemovePerDiem < ActiveRecord::Migration
  def up
    remove_column :transactions, :start
    remove_column :transactions, :finish
    remove_column :transactions, :per_diem
  end

  def down
  end
end
