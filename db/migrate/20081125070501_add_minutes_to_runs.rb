class AddMinutesToRuns < ActiveRecord::Migration
  def self.up
    add_column :runs, :minutes, :integer, :default=>0
    Run.update_all "minutes = 50"
  end

  def self.down
    remove_column :runs, :minutes
  end
end
