class AccountingRecurrings < ActiveRecord::Migration
  def up
    rename_column :recurrings, :value, :amount
    remove_column :recurrings, :description

    add_column :recurrings, :debit_id, :integer
    add_column :recurrings, :credit_id, :integer
  end

  def down
    remove_column :recurrings, :credit_id
    remove_column :recurrings, :debit_id

    add_column :recurrings, :description, :text
    rename_column :recurrings, :amount, :value
  end
end
