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

ActiveRecord::Schema[8.1].define(version: 2026_01_26_220334) do
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

  create_table "admin_preferences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "last_seen_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_admin_preferences_on_user_id"
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
    t.text "address"
    t.integer "age"
    t.string "blood_group"
    t.datetime "created_at", null: false
    t.string "designation"
    t.date "dob"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.string "emp_id"
    t.integer "employment_type"
    t.string "first_name"
    t.integer "gender"
    t.date "joining_date"
    t.string "last_name"
    t.string "phone"
    t.decimal "salary", precision: 10, scale: 2
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["emp_id"], name: "index_employee_profiles_on_emp_id", unique: true
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

  create_table "letter_templates", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "letter_type", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["letter_type", "active"], name: "index_letter_templates_on_letter_type_and_active"
  end

  create_table "letters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "issued_on", null: false
    t.bigint "letter_template_id", null: false
    t.integer "letter_type", null: false
    t.jsonb "metadata", default: {}, null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["issued_on"], name: "index_letters_on_issued_on"
    t.index ["letter_template_id"], name: "index_letters_on_letter_template_id"
    t.index ["user_id", "letter_type"], name: "index_letters_on_user_id_and_letter_type"
    t.index ["user_id"], name: "index_letters_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "kind"
    t.text "message"
    t.datetime "read_at"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "deductions_monthly", precision: 12, scale: 2
    t.decimal "deductions_payable", precision: 12, scale: 2
    t.decimal "gross_monthly", precision: 12, scale: 2
    t.decimal "gross_payable", precision: 12, scale: 2
    t.decimal "gross_salary", precision: 10, scale: 2
    t.boolean "locked", default: false, null: false
    t.date "month"
    t.decimal "net_payable", precision: 12, scale: 2
    t.decimal "net_salary", precision: 10, scale: 2
    t.decimal "paid_days", precision: 5, scale: 2
    t.decimal "payable_days"
    t.decimal "payable_ratio", precision: 6, scale: 4
    t.decimal "unpaid_days", precision: 5, scale: 2
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["month", "locked"], name: "index_payrolls_on_month_and_locked"
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

  create_table "salary_components", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "calculation_mode", default: 0, null: false
    t.integer "component_type", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "percent_of"
    t.bigint "salary_structure_id", null: false
    t.datetime "updated_at", null: false
    t.index ["salary_structure_id"], name: "index_salary_components_on_salary_structure_id"
  end

  create_table "salary_structures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "effective_from", null: false
    t.text "notes"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "status"], name: "index_salary_structures_on_user_id_and_status"
    t.index ["user_id"], name: "index_salary_structures_on_user_id"
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
  add_foreign_key "admin_preferences", "users"
  add_foreign_key "attendance_regularizations", "users"
  add_foreign_key "attendances", "users"
  add_foreign_key "employee_profiles", "users"
  add_foreign_key "leave_balances", "users"
  add_foreign_key "leave_requests", "users"
  add_foreign_key "letters", "letter_templates"
  add_foreign_key "letters", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "payrolls", "users"
  add_foreign_key "payslip_requests", "users"
  add_foreign_key "salary_components", "salary_structures"
  add_foreign_key "salary_structures", "users"
end
