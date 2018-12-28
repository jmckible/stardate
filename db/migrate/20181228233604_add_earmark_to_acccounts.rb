class AddEarmarkToAcccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :earmark, :boolean, default: false
    remove_index :accounts, :asset
    add_index :accounts, [:asset, :earmark]
  end
end
