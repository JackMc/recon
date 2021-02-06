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

ActiveRecord::Schema.define(version: 2021_02_06_004400) do

  create_table "domains", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "fqdn"
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "scans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "seed_type"
    t.bigint "seed_id"
    t.string "description"
    t.json "metadata"
    t.string "status"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.bigint "target_id"
    t.string "type"
    t.index ["seed_type", "seed_id"], name: "index_scans_on_scan_source"
  end

  create_table "targets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
