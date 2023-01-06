class CreateTransactions < ActiveRecord::Migration
  def change
    rename_table :items, :transactions
    add_column :transactions, :debit_id,  :integer
    add_column :transactions, :credit_id, :integer

    rename_column :transactions, :value, :amount

    Household.all.each do |household|
      cash = household.accounts.asset.first
      household.transactions.update_all "debit_id = #{cash.id}", "amount >= 0"
      household.transactions.update_all "credit_id = #{cash.id}", "amount < 0"
    end

  end
end
