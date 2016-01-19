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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160118231732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "household_id"
    t.integer  "budget"
    t.integer  "deferral_id"
    t.boolean  "asset",                    default: false
    t.boolean  "income",                   default: false
    t.boolean  "expense",                  default: false
    t.string   "name",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "dashboard",                default: false
    t.boolean  "accruing",                 default: false
  end

  add_index "accounts", ["asset"], name: "index_accounts_on_asset", using: :btree
  add_index "accounts", ["dashboard"], name: "index_accounts_on_dashboard", using: :btree
  add_index "accounts", ["deferral_id"], name: "index_accounts_on_deferral_id", using: :btree
  add_index "accounts", ["expense"], name: "index_accounts_on_expense", using: :btree
  add_index "accounts", ["household_id"], name: "index_accounts_on_household_id", using: :btree
  add_index "accounts", ["income"], name: "index_accounts_on_income", using: :btree

  create_table "budgets", force: :cascade do |t|
    t.integer  "household_id"
    t.integer  "amount"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",         limit: 255
  end

  add_index "budgets", ["household_id"], name: "index_budgets_on_household_id", using: :btree

  create_table "households", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "savings_goal",                  default: 0
    t.integer  "cash_id"
    t.integer  "slush_id"
    t.integer  "general_income_id"
  end

  add_index "households", ["cash_id"], name: "index_households_on_cash_id", using: :btree
  add_index "households", ["general_income_id"], name: "index_households_on_general_income_id", using: :btree
  add_index "households", ["slush_id"], name: "index_households_on_slush_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "user_id",                                               null: false
    t.date     "date",                                                  null: false
    t.integer  "value",                                 default: 0,     null: false
    t.text     "description"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurring_id"
    t.date     "start"
    t.date     "finish"
    t.decimal  "per_diem",     precision: 10, scale: 2
    t.integer  "household_id"
    t.boolean  "secret",                                default: false
  end

  add_index "items", ["date"], name: "index_items_on_date", using: :btree
  add_index "items", ["finish"], name: "index_items_on_finish", using: :btree
  add_index "items", ["household_id"], name: "index_items_on_household_id", using: :btree
  add_index "items", ["recurring_id"], name: "index_items_on_recurring_id", using: :btree
  add_index "items", ["start"], name: "index_items_on_start", using: :btree
  add_index "items", ["user_id"], name: "index_items_on_user_id", using: :btree
  add_index "items", ["vendor_id"], name: "index_items_on_vendor_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "user_id",                                                       null: false
    t.string   "name",       limit: 255,                                        null: false
    t.boolean  "active",                                         default: true
    t.datetime "created_at"
    t.decimal  "rate",                   precision: 6, scale: 2, default: 0.0,  null: false
    t.integer  "vendor_id"
  end

  add_index "jobs", ["user_id"], name: "index_projects_on_user_id", using: :btree
  add_index "jobs", ["vendor_id"], name: "index_jobs_on_vendor_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "body"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "paychecks", force: :cascade do |t|
    t.integer  "job_id",                                                        null: false
    t.integer  "item_id"
    t.datetime "created_at"
    t.string   "description", limit: 255
    t.decimal  "value",                   precision: 8, scale: 2, default: 0.0, null: false
  end

  add_index "paychecks", ["item_id"], name: "index_paychecks_on_item_id", using: :btree
  add_index "paychecks", ["job_id"], name: "index_paychecks_on_job_id", using: :btree

  create_table "recurrings", force: :cascade do |t|
    t.integer "user_id",               null: false
    t.integer "day",       default: 1, null: false
    t.integer "amount",    default: 0, null: false
    t.integer "vendor_id"
    t.integer "debit_id"
    t.integer "credit_id"
  end

  add_index "recurrings", ["day"], name: "index_recurrings_on_day", using: :btree
  add_index "recurrings", ["user_id"], name: "index_recurrings_on_user_id", using: :btree
  add_index "recurrings", ["vendor_id"], name: "index_recurrings_on_vendor_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_item_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name",      limit: 255
    t.string "permalink", limit: 255
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["permalink"], name: "index_tags_on_permalink", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "job_id",                              null: false
    t.datetime "created_at"
    t.date     "date",                                null: false
    t.integer  "minutes",                 default: 0, null: false
    t.string   "description", limit: 255
    t.integer  "paycheck_id"
  end

  add_index "tasks", ["date"], name: "index_tasks_on_date", using: :btree
  add_index "tasks", ["job_id"], name: "index_tasks_on_project_id", using: :btree
  add_index "tasks", ["paycheck_id"], name: "index_tasks_on_paycheck_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.date     "date",                         null: false
    t.integer  "amount",       default: 0,     null: false
    t.text     "description"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurring_id"
    t.integer  "household_id"
    t.boolean  "secret",       default: false
    t.integer  "debit_id"
    t.integer  "credit_id"
    t.boolean  "exceptional",  default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",         limit: 255,                                 null: false
    t.string   "password_salt", limit: 255,                                 null: false
    t.string   "password_hash", limit: 255,                                 null: false
    t.string   "time_zone",     limit: 255
    t.datetime "created_at",                default: '2007-05-24 15:49:54'
    t.integer  "household_id"
    t.string   "name",          limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["household_id"], name: "index_users_on_household_id", using: :btree

  create_table "vendors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink",  limit: 255
  end

  add_index "vendors", ["permalink"], name: "index_vendors_on_permalink", using: :btree

  create_table "weights", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.decimal  "weight",     precision: 4, scale: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weights", ["date"], name: "index_weights_on_date", using: :btree
  add_index "weights", ["user_id"], name: "index_weights_on_user_id", using: :btree

  create_table "workouts", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.integer  "minutes"
    t.decimal  "distance",                precision: 10, scale: 2
    t.string   "description", limit: 255
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.boolean  "bike",                                             default: false
    t.boolean  "elliptical",                                       default: false
    t.boolean  "nike",                                             default: false
    t.boolean  "p90x",                                             default: false
    t.boolean  "run",                                              default: false
    t.boolean  "walk",                                             default: false
    t.boolean  "yoga",                                             default: false
  end

  add_index "workouts", ["bike"], name: "index_workouts_on_bike", using: :btree
  add_index "workouts", ["date"], name: "index_workouts_on_date", using: :btree
  add_index "workouts", ["elliptical"], name: "index_workouts_on_elliptical", using: :btree
  add_index "workouts", ["nike"], name: "index_workouts_on_nike", using: :btree
  add_index "workouts", ["p90x"], name: "index_workouts_on_p90x", using: :btree
  add_index "workouts", ["run"], name: "index_workouts_on_run", using: :btree
  add_index "workouts", ["user_id"], name: "index_workouts_on_user_id", using: :btree
  add_index "workouts", ["walk"], name: "index_workouts_on_walk", using: :btree
  add_index "workouts", ["yoga"], name: "index_workouts_on_yoga", using: :btree

end
