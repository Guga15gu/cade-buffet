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

ActiveRecord::Schema[7.1].define(version: 2024_04_28_213319) do
  create_table "buffet_owner_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_buffet_owner_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_buffet_owner_users_on_reset_password_token", unique: true
  end

  create_table "buffet_type_prices", force: :cascade do |t|
    t.integer "base_price_weekday"
    t.integer "additional_per_person_weekday"
    t.integer "additional_per_hour_weekday"
    t.integer "base_price_weekend"
    t.integer "additional_per_person_weekend"
    t.integer "additional_per_hour_weekend"
    t.integer "buffet_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_type_id"], name: "index_buffet_type_prices_on_buffet_type_id"
  end

  create_table "buffet_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "max_capacity_people"
    t.integer "min_capacity_people"
    t.integer "duration"
    t.string "menu"
    t.boolean "alcoholic_beverages"
    t.boolean "decoration"
    t.boolean "parking_valet"
    t.boolean "exclusive_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "buffet_id", null: false
    t.index ["buffet_id"], name: "index_buffet_types_on_buffet_id"
  end

  create_table "buffets", force: :cascade do |t|
    t.string "business_name"
    t.string "corporate_name"
    t.string "registration_number"
    t.string "contact_phone"
    t.string "address"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "postal_code"
    t.string "description"
    t.string "payment_methods"
    t.integer "buffet_owner_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_owner_user_id"], name: "index_buffets_on_buffet_owner_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  add_foreign_key "buffet_type_prices", "buffet_types"
  add_foreign_key "buffet_types", "buffets"
  add_foreign_key "buffets", "buffet_owner_users"
end
