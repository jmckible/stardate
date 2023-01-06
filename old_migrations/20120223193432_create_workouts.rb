class CreateWorkouts < ActiveRecord::Migration
  def up
    create_table :workouts do |t|
      t.string :type
      t.integer :user_id
      t.date :date
      t.integer :minutes
      t.decimal :distance, :precision => 10, :scale => 2
      t.string :description

      t.timestamps
    end
    add_index :workouts, :type
    add_index :workouts, :user_id
    add_index :workouts, :date
  end
  
  
  def down
    drop_table :workouts
  end
end
