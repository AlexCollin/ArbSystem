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

ActiveRecord::Schema.define(version: 20170722101242) do

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

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "adv_type"
    t.boolean  "incremental_views", default: true
    t.string   "payment_model"
    t.float    "traffic_cost"
    t.float    "lead_cost"
    t.integer  "views"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "offer_id"
    t.integer  "source_id"
    t.integer  "parent_id"
    t.integer  "landing_id"
    t.string   "integration"
    t.string   "integration_offer"
    t.integer  "total_views"
    t.index ["landing_id"], name: "index_campaigns_on_landing_id", using: :btree
    t.index ["offer_id"], name: "index_campaigns_on_offer_id", using: :btree
    t.index ["parent_id"], name: "index_campaigns_on_parent_id", using: :btree
    t.index ["source_id"], name: "index_campaigns_on_source_id", using: :btree
  end

  create_table "campaigns_creatives", force: :cascade do |t|
    t.integer  "views"
    t.integer  "total_views"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "campaign_id"
    t.integer  "creative_id"
    t.index ["campaign_id"], name: "index_campaigns_creatives_on_campaign_id", using: :btree
    t.index ["creative_id"], name: "index_campaigns_creatives_on_creative_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "categories_offers", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "offer_id",    null: false
    t.index ["category_id"], name: "index_categories_offers_on_category_id", using: :btree
    t.index ["offer_id"], name: "index_categories_offers_on_offer_id", using: :btree
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
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "visitor_id"
    t.integer  "activity"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_campaign"
    t.string   "utm_content"
    t.string   "utm_term"
    t.integer  "campaign_id"
    t.integer  "creative_id"
    t.index ["campaign_id"], name: "index_clicks_on_campaign_id", using: :btree
    t.index ["creative_id"], name: "index_clicks_on_creative_id", using: :btree
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
    t.integer  "campaign_id"
    t.integer  "creative_id"
    t.index ["campaign_id"], name: "index_conversions_on_campaign_id", using: :btree
    t.index ["click_id"], name: "index_conversions_on_click_id", using: :btree
    t.index ["creative_id"], name: "index_conversions_on_creative_id", using: :btree
    t.index ["visitor_id"], name: "index_conversions_on_visitor_id", using: :btree
  end

  create_table "creatives", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "offer_id"
    t.string   "title"
    t.string   "text"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["offer_id"], name: "index_creatives_on_offer_id", using: :btree
  end

  create_table "landings", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.boolean  "is_external", default: false
    t.boolean  "is_transit",  default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "offers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
  end

  create_table "visitors", force: :cascade do |t|
    t.inet     "ip"
    t.string   "ua"
    t.string   "ident"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
