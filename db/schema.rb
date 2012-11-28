# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121128021811) do

  create_table "accounts", :force => true do |t|
    t.integer  "household_id"
    t.integer  "budget"
    t.integer  "deferral_id"
    t.boolean  "asset",        :default => false
    t.boolean  "liability",    :default => false
    t.boolean  "income",       :default => false
    t.boolean  "equity",       :default => false
    t.boolean  "expense",      :default => false
    t.boolean  "deferred",     :default => false
    t.string   "name"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "slush",        :default => false
    t.boolean  "dashboard",    :default => false
    t.boolean  "cash",         :default => false
  end

  add_index "accounts", ["asset"], :name => "index_accounts_on_asset"
  add_index "accounts", ["cash"], :name => "index_accounts_on_cash"
  add_index "accounts", ["dashboard"], :name => "index_accounts_on_dashboard"
  add_index "accounts", ["deferral_id"], :name => "index_accounts_on_deferral_id"
  add_index "accounts", ["deferred"], :name => "index_accounts_on_deferred"
  add_index "accounts", ["equity"], :name => "index_accounts_on_equity"
  add_index "accounts", ["expense"], :name => "index_accounts_on_expense"
  add_index "accounts", ["household_id"], :name => "index_accounts_on_household_id"
  add_index "accounts", ["income"], :name => "index_accounts_on_income"
  add_index "accounts", ["liability"], :name => "index_accounts_on_liability"
  add_index "accounts", ["slush"], :name => "index_accounts_on_slush"

  create_table "budgets", :force => true do |t|
    t.integer  "household_id"
    t.integer  "amount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
  end

  add_index "budgets", ["household_id"], :name => "index_budgets_on_household_id"

  create_table "households", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "savings_goal", :default => 0
  end

  create_table "jobs", :force => true do |t|
    t.integer  "user_id",                                                    :null => false
    t.string   "name",                                                       :null => false
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

  add_index "paychecks", ["item_id"], :name => "index_paychecks_on_item_id"
  add_index "paychecks", ["job_id"], :name => "index_paychecks_on_job_id"

  create_table "recurrings", :force => true do |t|
    t.integer "user_id",                    :null => false
    t.integer "day",         :default => 1, :null => false
    t.integer "value",       :default => 0, :null => false
    t.text    "description"
    t.integer "vendor_id"
  end

  add_index "recurrings", ["day"], :name => "index_recurrings_on_day"
  add_index "recurrings", ["user_id"], :name => "index_recurrings_on_user_id"
  add_index "recurrings", ["vendor_id"], :name => "index_recurrings_on_vendor_id"

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
    t.string "permalink"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"
  add_index "tags", ["permalink"], :name => "index_tags_on_permalink"

  create_table "tasks", :force => true do |t|
    t.integer  "job_id",                     :null => false
    t.datetime "created_at"
    t.date     "date",                       :null => false
    t.integer  "minutes",     :default => 0, :null => false
    t.string   "description"
    t.integer  "paycheck_id"
  end

  add_index "tasks", ["date"], :name => "index_tasks_on_date"
  add_index "tasks", ["job_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["paycheck_id"], :name => "index_tasks_on_paycheck_id"

  create_table "transactions", :force => true do |t|
    t.integer  "user_id",                                                        :null => false
    t.date     "date",                                                           :null => false
    t.integer  "amount",                                      :default => 0,     :null => false
    t.text     "description"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurring_id"
    t.date     "start"
    t.date     "finish"
    t.decimal  "per_diem",     :precision => 10, :scale => 2
    t.integer  "household_id"
    t.boolean  "secret",                                      :default => false
    t.integer  "debit_id"
    t.integer  "credit_id"
  end

  add_index "transactions", ["date"], :name => "index_items_on_date"
  add_index "transactions", ["finish"], :name => "index_items_on_finish"
  add_index "transactions", ["household_id"], :name => "index_items_on_household_id"
  add_index "transactions", ["recurring_id"], :name => "index_items_on_recurring_id"
  add_index "transactions", ["start"], :name => "index_items_on_start"
  add_index "transactions", ["user_id"], :name => "index_items_on_user_id"
  add_index "transactions", ["vendor_id"], :name => "index_items_on_vendor_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                            :null => false
    t.string   "password_salt",                                    :null => false
    t.string   "password_hash",                                    :null => false
    t.string   "time_zone"
    t.datetime "created_at",    :default => '2007-05-24 15:49:54'
    t.integer  "household_id"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["household_id"], :name => "index_users_on_household_id"

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "vendors", ["permalink"], :name => "index_vendors_on_permalink"

  create_table "weights", :force => true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.decimal  "weight",     :precision => 4, :scale => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weights", ["date"], :name => "index_weights_on_date"
  add_index "weights", ["user_id"], :name => "index_weights_on_user_id"

  create_table "workouts", :force => true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.integer  "minutes"
    t.decimal  "distance",    :precision => 10, :scale => 2
    t.string   "description"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.boolean  "bike",                                       :default => false
    t.boolean  "elliptical",                                 :default => false
    t.boolean  "nike",                                       :default => false
    t.boolean  "p90x",                                       :default => false
    t.boolean  "run",                                        :default => false
    t.boolean  "walk",                                       :default => false
  end

  add_index "workouts", ["bike"], :name => "index_workouts_on_bike"
  add_index "workouts", ["date"], :name => "index_workouts_on_date"
  add_index "workouts", ["elliptical"], :name => "index_workouts_on_elliptical"
  add_index "workouts", ["nike"], :name => "index_workouts_on_nike"
  add_index "workouts", ["p90x"], :name => "index_workouts_on_p90x"
  add_index "workouts", ["run"], :name => "index_workouts_on_run"
  add_index "workouts", ["user_id"], :name => "index_workouts_on_user_id"
  add_index "workouts", ["walk"], :name => "index_workouts_on_walk"

end
