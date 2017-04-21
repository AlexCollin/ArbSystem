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

ActiveRecord::Schema.define(version: 20170421173929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "clicks", force: :cascade do |t|
    t.text     "referer"
    t.float    "cpc"
    t.integer  "amount"
    t.string   "s1"
    t.string   "s2"
    t.string   "s3"
    t.string   "s4"
    t.string   "s5"
    t.string   "s6"
    t.string   "s7"
    t.string   "s8"
    t.string   "s9"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.integer  "visitor_id"
    t.boolean  "is_load_js",               default: false
    t.index ["visitor_id"], name: "index_clicks_on_visitor_id", using: :btree
  end

  create_table "conversions", force: :cascade do |t|
    t.integer  "click_id"
    t.string   "client_name"
    t.string   "client_phone"
    t.string   "client_address"
    t.string   "client_comment"
    t.json     "extra"
    t.integer  "status"
    t.string   "ext_id"
    t.string   "ext_comment"
    t.string   "ext_payout"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "visitor_id"
    t.index ["click_id"], name: "index_conversions_on_click_id", using: :btree
    t.index ["visitor_id"], name: "index_conversions_on_visitor_id", using: :btree
  end

  create_table "visitors", force: :cascade do |t|
    t.inet     "ip"
    t.string   "ua"
    t.string   "ident"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
