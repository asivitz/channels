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

ActiveRecord::Schema.define(:version => 20110318213317) do

  create_table "branches", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "parent_branch_id"
    t.integer  "root_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channelconfigs", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "last_checked"
  end

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "poster"
    t.text     "content"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "users", :force => true do |t|
    t.string   "alias"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
