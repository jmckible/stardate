class AddRecurringIdToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :recurring_id, :integer
    add_index  :items, :recurring_id
  end

  def self.down
    remove_column :items, :recurring_id
  end
end
