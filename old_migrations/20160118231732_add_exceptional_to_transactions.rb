class AddExceptionalToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :exceptional, :boolean, default: false
  end
end
