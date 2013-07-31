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

ActiveRecord::Schema.define(:version => 20130722154222) do

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

  create_table "metadata_fields", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "type"
    t.integer  "allowed_values_list_id"
    t.datetime "deleted_at"
    t.integer  "created_by_id",          :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "metadata_fields", ["allowed_values_list_id"], :name => "index_metadata_fields_on_allowed_values_list_id"

  create_table "metadata_list_values", :force => true do |t|
    t.string   "value",                   :null => false
    t.string   "description"
    t.integer  "metadata_values_list_id"
    t.datetime "deleted_at"
    t.integer  "created_by_id",           :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "metadata_list_values", ["metadata_values_list_id"], :name => "index_metadata_list_values_on_metadata_values_list_id"

  create_table "metadata_template_field_settings", :force => true do |t|
    t.integer  "metadata_field_id",    :null => false
    t.integer  "metadata_template_id", :null => false
    t.boolean  "required",             :null => false
    t.integer  "order",                :null => false
    t.datetime "deleted_at"
    t.integer  "created_by_id",        :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "metadata_template_field_settings", ["metadata_field_id"], :name => "index_metadata_template_field_settings_on_metadata_field_id"
  add_index "metadata_template_field_settings", ["metadata_template_id"], :name => "index_metadata_template_field_settings_on_metadata_template_id"

  create_table "metadata_templates", :force => true do |t|
    t.string   "name",          :null => false
    t.text     "description"
    t.datetime "deleted_at"
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "metadata_values_lists", :force => true do |t|
    t.string   "name",          :null => false
    t.string   "description"
    t.datetime "deleted_at"
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "metadatum_values", :force => true do |t|
    t.integer  "asset_id",           :null => false
    t.integer  "metadatum_field_id", :null => false
    t.string   "metadatum_value",    :null => false
    t.integer  "created_by_id",      :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "metadatum_values", ["asset_id"], :name => "index_metadatum_values_on_asset_id"
  add_index "metadatum_values", ["metadatum_field_id"], :name => "index_metadatum_values_on_metadatum_field_id"

  create_table "portfolios", :force => true do |t|
    t.string   "name",                 :null => false
    t.string   "description"
    t.integer  "metadata_template_id"
    t.integer  "created_by_id",        :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "asset_id",      :null => false
    t.integer  "portfolio_id",  :null => false
    t.datetime "deleted_at"
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "relationships", ["asset_id"], :name => "index_relationships_on_asset_id"
  add_index "relationships", ["portfolio_id"], :name => "index_relationships_on_portfolio_id"

  create_table "users", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "created_by_id",                          :null => false
    t.integer  "updated_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
