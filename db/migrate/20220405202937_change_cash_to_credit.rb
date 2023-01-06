class ChangeCashToCredit < ActiveRecord::Migration[7.0]
  def change
    add_column :households, :credit_card_id, :integer
    rename_column :households, :cash_id, :checking_id
  end
end
