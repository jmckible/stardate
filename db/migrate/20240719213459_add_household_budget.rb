class AddHouseholdBudget < ActiveRecord::Migration[7.1]
  def change
    add_column :households, :monthly_budget_target, :integer, default: 0
  end
end
