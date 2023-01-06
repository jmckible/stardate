class RenameTimeZone < ActiveRecord::Migration
  def self.up
    rename_column :users, :timezone, :time_zone
  end

  def self.down
    rename_column :users, :time_zonze, :timezone
  end
end
