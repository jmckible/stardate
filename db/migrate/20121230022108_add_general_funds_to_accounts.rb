class AddGeneralFundsToAccounts < ActiveRecord::Migration
  def change
    add_column :households, :cash_id, :integer
    add_index  :households, :cash_id

    add_column :households, :slush_id, :integer
    add_index  :households, :slush_id

    add_column :households, :general_income_id, :integer
    add_index  :households, :general_income_id
  end
end
