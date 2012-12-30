class RemoveEquityAndLiabilityAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :equity
    remove_column :accounts, :liability
  end

  def down
    add_column :accounts, :equity, :boolean, :default=>false
    add_column :accounts, :liability, :boolean, :default=>false
  end
end
