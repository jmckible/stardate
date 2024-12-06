# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_06_213124) do
  create_schema "heroku_ext"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.integer "household_id"
    t.integer "budget"
    t.integer "deferral_id"
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "dashboard", default: false
    t.boolean "accruing", default: false
    t.integer "status", default: 0
    t.boolean "earmark", default: false
    t.integer "ledger"
    t.index ["dashboard"], name: "index_accounts_on_dashboard"
    t.index ["deferral_id"], name: "index_accounts_on_deferral_id"
    t.index ["earmark"], name: "index_accounts_on_earmark"
    t.index ["household_id"], name: "index_accounts_on_household_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "budgets", id: :serial, force: :cascade do |t|
    t.integer "household_id"
    t.integer "amount"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name", limit: 255
    t.index ["household_id"], name: "index_budgets_on_household_id"
  end

  create_table "households", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "savings_goal", default: 0
    t.integer "checking_id"
    t.integer "slush_id"
    t.integer "general_income_id"
    t.integer "credit_card_id"
    t.integer "monthly_budget_target", default: 0
    t.index ["checking_id"], name: "index_households_on_checking_id"
    t.index ["general_income_id"], name: "index_households_on_general_income_id"
    t.index ["slush_id"], name: "index_households_on_slush_id"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date", null: false
    t.integer "value", default: 0, null: false
    t.text "description"
    t.integer "vendor_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "recurring_id"
    t.date "start"
    t.date "finish"
    t.decimal "per_diem", precision: 10, scale: 2
    t.integer "household_id"
    t.boolean "secret", default: false
    t.index ["date"], name: "index_items_on_date"
    t.index ["finish"], name: "index_items_on_finish"
    t.index ["household_id"], name: "index_items_on_household_id"
    t.index ["recurring_id"], name: "index_items_on_recurring_id"
    t.index ["start"], name: "index_items_on_start"
    t.index ["user_id"], name: "index_items_on_user_id"
    t.index ["vendor_id"], name: "index_items_on_vendor_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", limit: 255, null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil
    t.decimal "rate", precision: 6, scale: 2, default: "0.0", null: false
    t.integer "vendor_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
    t.index ["vendor_id"], name: "index_jobs_on_vendor_id"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.text "body"
    t.date "date"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "paychecks", id: :serial, force: :cascade do |t|
    t.integer "job_id", null: false
    t.integer "item_id"
    t.datetime "created_at", precision: nil
    t.string "description", limit: 255
    t.decimal "value", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["item_id"], name: "index_paychecks_on_item_id"
    t.index ["job_id"], name: "index_paychecks_on_job_id"
  end

  create_table "recurrings", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "day", default: 1, null: false
    t.integer "amount", default: 0, null: false
    t.integer "vendor_id"
    t.integer "debit_id"
    t.integer "credit_id"
    t.index ["day"], name: "index_recurrings_on_day"
    t.index ["user_id"], name: "index_recurrings_on_user_id"
    t.index ["vendor_id"], name: "index_recurrings_on_vendor_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.binary "payload", null: false
    t.datetime "created_at", null: false
    t.bigint "channel_hash", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_solid_cache_entries_on_key", unique: true
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type", limit: 255
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id"], name: "index_taggings_on_item_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "permalink", limit: 255
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["permalink"], name: "index_tags_on_permalink"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.integer "job_id", null: false
    t.datetime "created_at", precision: nil
    t.date "date", null: false
    t.integer "minutes", default: 0, null: false
    t.string "description", limit: 255
    t.integer "paycheck_id"
    t.index ["date"], name: "index_tasks_on_date"
    t.index ["job_id"], name: "index_tasks_on_project_id"
    t.index ["paycheck_id"], name: "index_tasks_on_paycheck_id"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date", null: false
    t.integer "amount", default: 0, null: false
    t.text "description"
    t.integer "vendor_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "recurring_id"
    t.integer "household_id"
    t.boolean "secret", default: false
    t.integer "debit_id"
    t.integer "credit_id"
    t.boolean "exceptional", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "password_digest", limit: 255, null: false
    t.string "time_zone", limit: 255
    t.datetime "created_at", precision: nil, default: "2007-05-24 15:49:54"
    t.integer "household_id"
    t.string "name", limit: 255
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["household_id"], name: "index_users_on_household_id"
  end

  create_table "vendors", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "permalink", limit: 255
    t.index ["name"], name: "index_vendors_on_name", unique: true
    t.index ["permalink"], name: "index_vendors_on_permalink"
  end

  create_table "weights", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.decimal "weight", precision: 4, scale: 1
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["date"], name: "index_weights_on_date"
    t.index ["user_id"], name: "index_weights_on_user_id"
  end

  create_table "workouts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.integer "minutes"
    t.decimal "distance", precision: 10, scale: 2
    t.string "description", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "bike", default: false
    t.boolean "elliptical", default: false
    t.boolean "nike", default: false
    t.boolean "p90x", default: false
    t.boolean "run", default: false
    t.boolean "walk", default: false
    t.boolean "yoga", default: false
    t.index ["bike"], name: "index_workouts_on_bike"
    t.index ["date"], name: "index_workouts_on_date"
    t.index ["elliptical"], name: "index_workouts_on_elliptical"
    t.index ["nike"], name: "index_workouts_on_nike"
    t.index ["p90x"], name: "index_workouts_on_p90x"
    t.index ["run"], name: "index_workouts_on_run"
    t.index ["user_id"], name: "index_workouts_on_user_id"
    t.index ["walk"], name: "index_workouts_on_walk"
    t.index ["yoga"], name: "index_workouts_on_yoga"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
