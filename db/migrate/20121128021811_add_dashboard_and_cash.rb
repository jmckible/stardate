class AddDashboardAndCash < ActiveRecord::Migration
  def change
    add_column :accounts, :dashboard, :boolean, :default=>false
    add_index  :accounts, :dashboard

    add_column :accounts, :cash, :boolean, :default=>false
    add_index  :accounts, :cash
  end
end
