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

ActiveRecord::Schema[7.0].define(version: 2023_04_29_143804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.uuid "user_id", null: false
    t.string "commentable_type", null: false
    t.uuid "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_riders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_trackers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "status", default: "pending", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_issue_trackers_on_user_id"
  end

  create_table "movements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "rate_id", null: false
    t.datetime "date"
    t.string "code", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_movements_on_code", unique: true
    t.index ["rate_id"], name: "index_movements_on_rate_id"
  end

  create_table "prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "priciable_type", null: false
    t.uuid "priciable_id", null: false
    t.decimal "quantity", precision: 8, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priciable_type", "priciable_id"], name: "index_prices_on_priciable"
  end

  create_table "product_movements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "movement_id", null: false
    t.uuid "variant_id", null: false
    t.integer "quantity"
    t.decimal "amount"
    t.boolean "return", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movement_id"], name: "index_product_movements_on_movement_id"
    t.index ["variant_id"], name: "index_product_movements_on_variant_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "kind"
    t.string "name"
    t.integer "stock", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "customer_id"
    t.uuid "zone_id", null: false
    t.string "kind", default: "delivery", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable", default: false, null: false
    t.string "name"
    t.uuid "delivery_rider_id"
    t.index ["customer_id"], name: "index_rates_on_customer_id"
    t.index ["delivery_rider_id"], name: "index_rates_on_delivery_rider_id"
    t.index ["zone_id"], name: "index_rates_on_zone_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "phone"
    t.string "role", default: "user", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id", null: false
    t.uuid "zone_id", null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["zone_id"], name: "index_variants_on_zone_id"
  end

  create_table "zones", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zones_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users"
  add_foreign_key "issue_trackers", "users"
  add_foreign_key "movements", "rates"
  add_foreign_key "product_movements", "movements"
  add_foreign_key "product_movements", "variants"
  add_foreign_key "rates", "customers"
  add_foreign_key "rates", "delivery_riders"
  add_foreign_key "rates", "zones"
  add_foreign_key "variants", "products"
  add_foreign_key "variants", "zones"
end
