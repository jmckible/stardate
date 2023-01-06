class TaskPaycheckIdCanBeNil < ActiveRecord::Migration
  def self.up
    change_column :tasks, :paycheck_id, :integer, :null=>true
  end

  def self.down
  end
end
