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

ActiveRecord::Schema[7.0].define(version: 2022_04_02_141336) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "domains", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "fqdn"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "target_id"
    t.bigint "source_scan_id"
    t.boolean "wildcard"
    t.index ["source_scan_id"], name: "index_domains_on_source_scan_id"
    t.index ["target_id", "fqdn"], name: "index_domains_on_target_id_and_fqdn", unique: true, length: { fqdn: 256 }
    t.index ["target_id"], name: "index_domains_on_target_id"
  end

  create_table "http_probes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "domain_id"
    t.text "http_response", size: :long
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_code"
    t.string "status_name"
    t.boolean "https"
    t.text "body", size: :long
    t.json "headers"
    t.text "raw_body", size: :long
    t.bigint "scan_id"
    t.string "failure_reason"
    t.boolean "failed"
    t.text "http_request", size: :long
    t.index ["domain_id"], name: "index_http_probes_on_domain_id"
  end

  create_table "scan_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "enumerate_domains"
    t.string "domain_pattern"
    t.boolean "http_probe"
    t.boolean "screenshot"
    t.boolean "response_diff"
    t.boolean "photo_diff"
    t.boolean "active"
    t.index ["target_id"], name: "index_scan_schedules_on_target_id"
  end

  create_table "scans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "seed_type"
    t.bigint "seed_id"
    t.string "description"
    t.json "metadata"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "target_id"
    t.string "type"
    t.bigint "scan_schedule_id"
    t.index ["scan_schedule_id"], name: "index_scans_on_scan_schedule_id"
    t.index ["seed_type", "seed_id"], name: "index_scans_on_scan_source"
  end

  create_table "tagged_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type"
    t.bigint "domain_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id", "tag_id"], name: "index_tagged_items_on_domain_id_and_tag_id", unique: true
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "targets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
