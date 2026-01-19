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

ActiveRecord::Schema[8.1].define(version: 2026_01_19_084459) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attendance_regularizations", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.date "date"
    t.text "reason"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_attendance_regularizations_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "worked_minutes"
    t.index ["user_id", "date"], name: "index_attendances_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "employee_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "designation"
    t.string "first_name"
    t.date "joining_date"
    t.string "last_name"
    t.decimal "salary", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_employee_profiles_on_user_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "leave_balances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "leave_type", null: false
    t.integer "total", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "used", default: 0, null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "leave_type"], name: "index_leave_balances_on_user_id_and_leave_type", unique: true
    t.index ["user_id"], name: "index_leave_balances_on_user_id"
  end

  create_table "leave_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.integer "leave_type"
    t.text "reason"
    t.date "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["status"], name: "index_leave_requests_on_status"
    t.index ["user_id"], name: "index_leave_requests_on_user_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "gross_salary", precision: 10, scale: 2
    t.date "month"
    t.decimal "net_salary", precision: 10, scale: 2
    t.decimal "paid_days", precision: 5, scale: 2
    t.decimal "payable_days"
    t.decimal "unpaid_days", precision: 5, scale: 2
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_payrolls_on_user_id"
  end

  create_table "payslip_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "month"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "month"], name: "index_payslip_requests_on_user_id_and_month", unique: true
    t.index ["user_id"], name: "index_payslip_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attendance_regularizations", "users"
  add_foreign_key "attendances", "users"
  add_foreign_key "employee_profiles", "users"
  add_foreign_key "leave_balances", "users"
  add_foreign_key "leave_requests", "users"
  add_foreign_key "payrolls", "users"
  add_foreign_key "payslip_requests", "users"
end
