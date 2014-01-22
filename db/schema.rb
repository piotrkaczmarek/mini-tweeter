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

ActiveRecord::Schema.define(version: 20140121210629) do

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rating"
    t.integer  "rated_by"
    t.integer  "answer_to_id"
    t.integer  "organization_id"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.string   "homesite_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "micropost_id"
  end

  add_index "rates", ["micropost_id", "user_id"], name: "index_rates_on_micropost_id_and_user_id", unique: true, using: :btree
  add_index "rates", ["micropost_id"], name: "index_rates_on_micropost_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "followed_organization_id"
  end

  add_index "relationships", ["followed_user_id"], name: "index_relationships_on_followed_user_id", using: :btree
  add_index "relationships", ["follower_id", "followed_user_id"], name: "index_relationships_on_follower_id_and_followed_user_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.integer  "organization_id"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
