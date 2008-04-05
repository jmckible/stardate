class AddUsersCreatedAt < ActiveRecord::Migration
  def self.up
    add_column :users, :created_at, :datetime, :default=>Time.now
  end

  def self.down
    remove_column :users, :created_at
  end
end
