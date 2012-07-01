class RemoveSingletonTagsFromBudgets < ActiveRecord::Migration
  def up
    remove_index  :budgets, [:household_id, :tag_id]
    remove_column :budgets, :tag_id
  end

  def down
    add_column :budgets, :tag_id, :integer
    add_index  :budgets, :tag_id
  end
end
