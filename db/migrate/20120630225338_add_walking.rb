class AddWalking < ActiveRecord::Migration
  def change
    add_column :workouts, :walk, :boolean, :default=>false
    add_index  :workouts, :walk
  end
end
