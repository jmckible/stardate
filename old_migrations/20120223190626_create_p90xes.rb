class CreateP90xes < ActiveRecord::Migration
  def change
    create_table :p90xes do |t|
      t.date :date
      t.integer :user_id
      t.integer :minutes
      t.string :description

      t.timestamps
    end
    add_index :p90xes, :date
    add_index :p90xes, :user_id
  end
end
