class AddSavingsGoalToHousehold < ActiveRecord::Migration
  def change
    add_column :households, :savings_goal, :integer, :default=>0
  end
end
