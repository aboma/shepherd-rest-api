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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121020004200) do

  create_table "assets", :force => true do |t|
    t.string   "name",          :null => false
    t.string   "file",          :null => false
    t.string   "description"
    t.datetime "deleted_at"
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "portfolios", :force => true do |t|
    t.string   "name",          :null => false
    t.string   "description"
    t.datetime "deleted_at"
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "relationships", :force => true do |t|
    t.string   "relationship_type"
    t.integer  "asset_id"
    t.integer  "portfolio_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                        :null => false
    t.string   "crypted_password",             :null => false
    t.string   "salt"
    t.string   "last_name"
    t.string   "first_name"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
