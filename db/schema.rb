# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081125070501) do

  create_table "items", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.date     "date",                        :null => false
    t.integer  "value",        :default => 0, :null => false
    t.text     "description"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurring_id"
  end

  add_index "items", ["user_id"], :name => "index_items_on_user_id"
  add_index "items", ["date"], :name => "index_items_on_date"
  add_index "items", ["vendor_id"], :name => "index_items_on_vendor_id"
  add_index "items", ["recurring_id"], :name => "index_items_on_recurring_id"

  create_table "jobs", :force => true do |t|
    t.integer  "user_id",                                                    :null => false
    t.string   "name",                                     :default => "",   :null => false
    t.boolean  "active",                                   :default => true
    t.datetime "created_at"
    t.decimal  "rate",       :precision => 6, :scale => 2, :default => 0.0,  :null => false
    t.integer  "vendor_id"
  end

  add_index "jobs", ["user_id"], :name => "index_projects_on_user_id"
  add_index "jobs", ["vendor_id"], :name => "index_jobs_on_vendor_id"

  create_table "notes", :force => true do |t|
    t.text     "body"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "paychecks", :force => true do |t|
    t.integer  "job_id",                                                     :null => false
    t.integer  "item_id"
    t.datetime "created_at"
    t.string   "description"
    t.decimal  "value",       :precision => 8, :scale => 2, :default => 0.0, :null => false
  end

  add_index "paychecks", ["job_id"], :name => "index_paychecks_on_job_id"
  add_index "paychecks", ["item_id"], :name => "index_paychecks_on_item_id"

  create_table "recurrings", :force => true do |t|
    t.integer "user_id",                    :null => false
    t.integer "day",         :default => 1, :null => false
    t.integer "value",       :default => 0, :null => false
    t.text    "description"
    t.integer "vendor_id"
  end

  add_index "recurrings", ["user_id"], :name => "index_recurrings_on_user_id"
  add_index "recurrings", ["day"], :name => "index_recurrings_on_day"
  add_index "recurrings", ["vendor_id"], :name => "index_recurrings_on_vendor_id"

  create_table "runs", :force => true do |t|
    t.date     "date"
    t.decimal  "distance",   :precision => 10, :scale => 2
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minutes",                                   :default => 0
  end

  add_index "runs", ["user_id"], :name => "index_runs_on_user_id"

  create_table "taggings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_item_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tasks", :force => true do |t|
    t.integer  "job_id",                     :null => false
    t.datetime "created_at"
    t.date     "date",                       :null => false
    t.integer  "minutes",     :default => 0, :null => false
    t.string   "description"
    t.integer  "paycheck_id"
  end

  add_index "tasks", ["job_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["paycheck_id"], :name => "index_tasks_on_paycheck_id"
  add_index "tasks", ["date"], :name => "index_tasks_on_date"

  create_table "users", :force => true do |t|
    t.string   "email",         :default => "",                    :null => false
    t.string   "password_salt", :default => "",                    :null => false
    t.string   "password_hash", :default => "",                    :null => false
    t.string   "time_zone"
    t.datetime "created_at",    :default => '2007-05-24 15:49:54'
  end

  add_index "users", ["email"], :name => "index_users_on_email"

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
