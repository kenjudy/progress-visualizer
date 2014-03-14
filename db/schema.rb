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

ActiveRecord::Schema.define(version: 20140313234842) do

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
    t.integer  "user_profile_id"
  end

  add_index "burn_ups", ["user_profile_id"], name: "index_burn_ups_on_user_profile_id", using: :btree

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
    t.integer  "user_profile_id"
  end

  add_index "done_stories", ["user_profile_id", "story_id"], name: "index_done_stories_on_user_profile_id_and_story_id", unique: true, using: :btree
  add_index "done_stories", ["user_profile_id"], name: "index_done_stories_on_user_profile_id", using: :btree

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id",                                                  null: false
    t.string   "name"
    t.binary   "default"
    t.string   "encrypted_readonly_token"
    t.string   "encrypted_current_sprint_board_id"
    t.string   "encrypted_current_sprint_board_id_short"
    t.string   "encrypted_backlog_lists"
    t.string   "encrypted_done_lists"
    t.string   "encrypted_readonly_token_iv"
    t.string   "encrypted_current_sprint_board_id_iv"
    t.string   "encrypted_current_sprint_board_id_short_iv"
    t.string   "encrypted_backlog_lists_iv"
    t.string   "encrypted_done_lists_iv"
    t.string   "encrypted_readonly_token_salt"
    t.string   "encrypted_current_sprint_board_id_salt"
    t.string   "encrypted_current_sprint_board_id_short_salt"
    t.string   "encrypted_backlog_lists_salt"
    t.string   "encrypted_done_lists_salt"
    t.string   "labels_types_of_work"
    t.integer  "duration"
    t.integer  "start_day_of_week",                            default: 1
    t.integer  "end_day_of_week",                              default: 6
    t.integer  "start_hour",                                   default: 0
    t.integer  "end_hour",                                     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "webhooks", force: true do |t|
    t.integer  "user_profile_id"
    t.string   "external_id"
    t.string   "callback_url"
    t.string   "id_model"
    t.string   "description"
    t.string   "last_run"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webhooks", ["user_profile_id"], name: "index_webhooks_on_user_profile_id", using: :btree

end
