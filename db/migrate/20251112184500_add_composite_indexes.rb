class AddCompositeIndexes < ActiveRecord::Migration[8.1]
  def change
    # Most critical: household_id + date (used in almost every query)
    # This will dramatically improve queries that filter by household AND date range
    add_index :transactions, [:household_id, :date]

    # For queries filtering by household + specific account
    # Improves Account#transactions and balance calculations
    add_index :transactions, [:household_id, :debit_id]
    add_index :transactions, [:household_id, :credit_id]

    # For expense/income queries that also filter by exceptional flag
    # Improves budget calculations
    add_index :transactions, [:household_id, :exceptional, :date]

    # For vendor-specific queries with date ranges
    add_index :transactions, [:household_id, :vendor_id, :date]

    # Remove single-column indexes that are now redundant
    # household_id is covered by the composite indexes above
    remove_index :transactions, :household_id

    # Keep these single-column indexes as they're still useful:
    # - date (for global date queries)
    # - user_id, vendor_id, debit_id, credit_id, recurring_id (for lookups)
    # - exceptional (for boolean filtering)

    # Optional: Index on accounts.ledger for JOIN queries
    # This eliminates the seq scan on accounts table
    add_index :accounts, :ledger
    add_index :accounts, [:household_id, :ledger]
  end
end
