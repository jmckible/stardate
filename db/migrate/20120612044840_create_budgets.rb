class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :household_id, :tag_id, :amount
      t.timestamps
    end
    add_index :budgets, :household_id
    add_index :budgets, :tag_id
    add_index :budgets,  [:household_id, :tag_id], :unique=>true
  end
end
