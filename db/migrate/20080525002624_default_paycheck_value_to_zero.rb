class DefaultPaycheckValueToZero < ActiveRecord::Migration
  def self.up
    change_column :paychecks, :value, :decimal, :precision => 8, :scale => 2, :null=>false, :default=>0.0
  end

  def self.down
  end
end
