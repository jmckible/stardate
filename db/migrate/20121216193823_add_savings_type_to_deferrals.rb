class AddSavingsTypeToDeferrals < ActiveRecord::Migration
  def change
    add_column :accounts, :accruing, :boolean, :default=>false
  end
end
