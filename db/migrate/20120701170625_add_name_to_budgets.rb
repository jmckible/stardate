class AddNameToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :name, :string
  end
end
