class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :household_id, :budget, :deferral_id
      t.boolean :asset, :liability, :income, :equity, :expense, :deferred, :default=>false
      t.string :name
      t.timestamps
    end

    add_index :accounts, :household_id
    add_index :accounts, :deferral_id
    add_index :accounts, :asset
    add_index :accounts, :liability
    add_index :accounts, :income
    add_index :accounts, :equity
    add_index :accounts, :expense
    add_index :accounts, :deferred

    Household.all.each do |household|
      cash = household.accounts.build name: 'Cash', asset: true
      cash.save

      household.budgets.each do |budget|
        deferred = household.accounts.build name: "#{budget.name} Deferral", budget: budget.amount, deferred: true
        deferred.save
        deferred.tags = budget.tags
        deferred.save

        expense = household.accounts.build name: budget.name, expense: true, deferral: deferred
        expense.save
        expense.tags = budget.tags
        expense.save
      end
    end

  end
end
