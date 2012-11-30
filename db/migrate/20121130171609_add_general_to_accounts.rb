class AddGeneralToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :general, :boolean, :default=>false
    add_index  :accounts, :general

    Account.all.each{|a|a.update_attribute(:general, true) if a.cash? || a.slush?}

    remove_column :accounts, :cash
    remove_column :accounts, :slush

  end
end
