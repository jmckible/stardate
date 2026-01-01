class AddMissingIndexes < ActiveRecord::Migration[8.1]
  def change
    # transactions table - most critical for performance
    add_index :transactions, :date
    add_index :transactions, :household_id
    add_index :transactions, :user_id
    add_index :transactions, :vendor_id
    add_index :transactions, :debit_id
    add_index :transactions, :credit_id
    add_index :transactions, :recurring_id
    add_index :transactions, :exceptional

    # taggings table - composite index for polymorphic queries
    add_index :taggings, [:taggable_type, :taggable_id]

    # notes table
    add_index :notes, :date
  end
end
