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

ActiveRecord::Schema.define(version: 20140201060358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "burn_ups", force: true do |t|
    t.datetime "timestamp"
    t.integer  "backlog"
    t.integer  "done"
    t.float    "backlog_estimates"
    t.float    "done_estimates"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "done_stories", force: true do |t|
    t.date     "timestamp"
    t.string   "iteration"
    t.string   "type_of_work"
    t.string   "status"
    t.string   "story_id"
    t.string   "story"
    t.float    "estimate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "done_stories", ["story_id"], name: "index_done_stories_on_story_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_hash"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
