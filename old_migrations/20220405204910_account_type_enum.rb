class AccountTypeEnum < ActiveRecord::Migration[7.0]
  def up
    add_column :accounts, :ledger, :integer

    Account.reset_column_information

    Account.all.each do |account|
      if account.asset
        account.ledger = 'asset'
      elsif account.income
        account.ledger = 'income'
      elsif account.expense
        account.ledger = 'expense'
      end
      account.save
    end

    remove_index :accounts, [:asset, :earmark]
    add_index :accounts, :earmark

    remove_index :accounts, :income
    remove_index :accounts, :expense

    remove_column :accounts, :asset
    remove_column :accounts, :income
    remove_column :accounts, :expense
  end
end
