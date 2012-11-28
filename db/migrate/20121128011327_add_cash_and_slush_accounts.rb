class AddCashAndSlushAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :slush, :boolean, :default=>false
    add_index  :accounts, :slush
  end

  def down
    remove_column :accounts, :slush
  end
end
