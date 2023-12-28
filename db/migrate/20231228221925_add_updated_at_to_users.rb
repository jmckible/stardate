class AddUpdatedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :updated_at, :datetime
  end
end
