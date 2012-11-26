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

ActiveRecord::Schema.define(:version => 20121120053217) do

  create_table "matches", :force => true do |t|
    t.integer  "season_id"
    t.integer  "week_number"
    t.integer  "first_team"
    t.integer  "second_team"
    t.integer  "slot"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "outcome",     :default => -1
  end

  create_table "results", :force => true do |t|
    t.integer  "match_id"
    t.integer  "shooter_id"
    t.integer  "sixteen_yards"
    t.integer  "handicap"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "is_blind_score", :default => false
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.integer  "houses"
    t.integer  "time_slots"
    t.float    "handicap_calculation"
    t.text     "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_id"
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shooters", :force => true do |t|
    t.integer  "team_id"
    t.integer  "position"
    t.string   "name"
    t.integer  "handicap_yardage"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.boolean  "casper"
  end

  create_table "teams", :force => true do |t|
    t.integer  "season_id"
    t.integer  "number"
    t.string   "name"
    t.text     "description"
    t.integer  "clean_up_week_number"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "provider"
    t.string   "uid"
  end

end
