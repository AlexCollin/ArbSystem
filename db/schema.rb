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

ActiveRecord::Schema.define(version: 20170706111133) do

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

  create_table "campaign_history", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "adv_type"
    t.boolean  "incremental_views", default: true
    t.string   "payment_model"
    t.float    "traffic_cost"
    t.float    "lead_cost"
    t.integer  "views_count"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "campaigns_id"
    t.index ["campaigns_id"], name: "index_campaign_history_on_campaigns_id", using: :btree
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "adv_type"
    t.boolean  "incremental_views", default: true
    t.string   "payment_model"
    t.float    "traffic_cost"
    t.float    "lead_cost"
    t.integer  "views_count"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "offers_id"
    t.integer  "sources_id"
    t.index ["offers_id"], name: "index_campaigns_on_offers_id", using: :btree
    t.index ["sources_id"], name: "index_campaigns_on_sources_id", using: :btree
  end

  create_table "campaigns_creatives", id: false, force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "creative_id", null: false
    t.index ["campaign_id"], name: "index_campaigns_creatives_on_campaign_id", using: :btree
    t.index ["creative_id"], name: "index_campaigns_creatives_on_creative_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "categories_offers", id: false, force: :cascade do |t|
    t.integer "offer_id",    null: false
    t.integer "category_id", null: false
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
    t.datetime "created_at",   precision: 6
    t.datetime "updated_at",   precision: 6
    t.integer  "visitor_id"
    t.integer  "activity"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_campaign"
    t.string   "utm_content"
    t.string   "utm_term"
    t.integer  "campaigns_id"
    t.index ["campaigns_id"], name: "index_clicks_on_campaigns_id", using: :btree
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
    t.integer  "campaigns_id"
    t.index ["campaigns_id"], name: "index_conversions_on_campaigns_id", using: :btree
    t.index ["click_id"], name: "index_conversions_on_click_id", using: :btree
    t.index ["visitor_id"], name: "index_conversions_on_visitor_id", using: :btree
  end

  create_table "creatives", force: :cascade do |t|
    t.integer  "views_count"
    t.string   "title"
    t.string   "text"
    t.string   "image"
    t.string   "descr"
    t.string   "title2"
    t.string   "text2"
    t.string   "image2"
    t.string   "descr2"
    t.string   "title3"
    t.string   "text3"
    t.string   "image3"
    t.string   "descr3"
    t.string   "title4"
    t.string   "text4"
    t.string   "image4"
    t.string   "descr4"
    t.string   "title5"
    t.string   "text5"
    t.string   "image5"
    t.string   "descr5"
    t.string   "title6"
    t.string   "text6"
    t.string   "image6"
    t.string   "descr6"
    t.string   "title7"
    t.string   "text7"
    t.string   "image7"
    t.string   "descr7"
    t.string   "title8"
    t.string   "text8"
    t.string   "image8"
    t.string   "descr8"
    t.string   "title9"
    t.string   "text9"
    t.string   "image9"
    t.string   "descr9"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
