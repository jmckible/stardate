class DefaultJobRateToZero < ActiveRecord::Migration
  def self.up
    change_column :jobs, :rate, :decimal, :precision => 6, :scale => 2, :null=>false, :default=>0.0
  end

  def self.down
  end
end
