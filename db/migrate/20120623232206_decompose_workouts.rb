class DecomposeWorkouts < ActiveRecord::Migration
  def up
    add_column :workouts, :bike, :boolean, :default=>false
    add_index  :workouts, :bike
    add_column :workouts, :elliptical, :boolean, :default=>false
    add_index  :workouts, :elliptical
    add_column :workouts, :nike, :boolean, :default=>false
    add_index  :workouts, :nike
    add_column :workouts, :p90x, :boolean, :default=>false
    add_index  :workouts, :p90x
    add_column :workouts, :run, :boolean, :default=>false
    add_index  :workouts, :run
    
    Workout.update_all "bike = '1'", "type = 'Bike'"
    Workout.update_all "elliptical = '1'", "type = 'Elliptical'"
    Workout.update_all "nike = '1'", "type = 'Nike'"
    Workout.update_all "p90x = '1'", "type = 'P90x'"
    Workout.update_all "run = '1'",  "type = 'Run'"
    
    remove_column :workouts, :type
  end

  def down
  end
end
