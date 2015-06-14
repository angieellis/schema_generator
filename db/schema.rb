# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150614032636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string  "payment_type"
    t.string  "account_number"
    t.text    "billing_address"
  end

  create_table "authors", force: :cascade do |t|
    t.integer  "authors_books_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "authors_books", force: :cascade do |t|
    t.integer "author_id"
    t.integer "book_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "bidder_id"
    t.float    "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.integer  "authors_books_id"
    t.string   "title"
    t.date     "publication_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "categories_items_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "categories_items", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "item_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categories_items", ["category_id", "item_id"], name: "index_categories_items_on_category_id_and_item_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "categories_items_id"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.string   "name"
    t.text     "description"
    t.float    "starting_price",      default: 0.0
    t.float    "price",               default: 0.0
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "sold",                default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "items", ["seller_id", "buyer_id"], name: "index_items_on_seller_id_and_buyer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "username"
    t.string   "password_hash"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
