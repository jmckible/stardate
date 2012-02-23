class DropIndividualWorkoutTables < ActiveRecord::Migration
  def up
    drop_table :bikes
    drop_table :ellipticals
    drop_table :nikes
    drop_table :p90xes
    drop_table :runs
  end

  def down
    create_table "bikes", :force => true do |t|
      t.date     "date"
      t.decimal  "distance",   :precision => 10, :scale => 2
      t.integer  "user_id"
      t.integer  "minutes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "bikes", ["user_id"], :name => "index_bikes_on_user_id"

    create_table "ellipticals", :force => true do |t|
      t.date     "date"
      t.decimal  "distance",   :precision => 10, :scale => 2
      t.integer  "user_id"
      t.integer  "minutes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ellipticals", ["user_id"], :name => "index_ellipticals_on_user_id"
    
    
    create_table "nikes", :force => true do |t|
      t.date     "date"
      t.integer  "user_id"
      t.integer  "minutes",     :default => 0
      t.string   "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "nikes", ["user_id"], :name => "index_nikes_on_user_id"
    
    create_table "p90xes", :force => true do |t|
      t.date     "date"
      t.integer  "user_id"
      t.integer  "minutes"
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "p90xes", ["date"], :name => "index_p90xes_on_date"
    add_index "p90xes", ["user_id"], :name => "index_p90xes_on_user_id"
    
    create_table "runs", :force => true do |t|
      t.date     "date"
      t.decimal  "distance",   :precision => 10, :scale => 2
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "minutes",                                   :default => 0
    end

    add_index "runs", ["user_id"], :name => "index_runs_on_user_id"
  end
end
