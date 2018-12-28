class AddAccountStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :status, :integer, default: 0
  end
end
