class ForgottenIndexes < ActiveRecord::Migration
  def self.up
    add_index :tasks, :project_id
    add_index :projects, :user_id
  end

  def self.down
    remove_index :tasks, :project_id
    remove_index :projects, :user_id
  end
end
