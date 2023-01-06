class AddYoga < ActiveRecord::Migration
  def change
    add_column :workouts, :yoga, :boolean, :default=>false
    add_index  :workouts, :yoga
  end
end
