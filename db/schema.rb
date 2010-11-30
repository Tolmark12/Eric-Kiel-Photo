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

ActiveRecord::Schema.define(:version => 20101109220233) do

  create_table "actions", :force => true do |t|
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions_roles", :id => false, :force => true do |t|
    t.integer "action_id"
    t.integer "role_id"
  end

  create_table "bento_users", :force => true do |t|
    t.string   "username"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bento_users", ["reset_password_token"], :name => "index_bento_users_on_reset_password_token", :unique => true
  add_index "bento_users", ["username"], :name => "index_bento_users_on_username", :unique => true

  create_table "bento_users_roles", :id => false, :force => true do |t|
    t.integer "bento_user_id"
    t.integer "role_id"
  end

  create_table "coming_soons", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_settings", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "config_settings", ["name"], :name => "index_config_settings_on_name", :unique => true

  create_table "nav_items", :force => true do |t|
    t.string   "name"
    t.integer  "nav_id"
    t.string   "url_id"
    t.string   "text"
    t.boolean  "is_logo"
    t.integer  "sub_id"
    t.string   "sub_type"
    t.integer  "page_type_id"
    t.string   "nav_filter_tag"
    t.boolean  "is_default"
    t.integer  "sort"
    t.integer  "serviceable_id"
    t.string   "serviceable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "navs", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "porfolio_items", :force => true do |t|
    t.string   "name"
    t.string   "src"
    t.string   "low_res_src"
    t.text     "video_embed_code"
    t.boolean  "is_video_only"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portfolio_items", :force => true do |t|
    t.string   "name"
    t.string   "src"
    t.string   "low_res_src"
    t.string   "video_embed_code"
    t.boolean  "is_video_only"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portfolios", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portfolios_portfolio_items", :id => false, :force => true do |t|
    t.integer "portfolio_id"
    t.integer "portfolio_item_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_tagables", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "tagable_id"
    t.string   "tagable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "text_id"
    t.string   "name"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
