class RemoveGeneralFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :general
  end

  def down
    add_column :accounts, :general, :boolean, :default=>false
  end
end
