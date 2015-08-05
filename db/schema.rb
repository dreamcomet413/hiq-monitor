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

ActiveRecord::Schema.define(version: 20150803070108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crash_groups", force: :cascade do |t|
    t.string   "file"
    t.string   "reason"
    t.string   "status"
    t.integer  "hockey_id"
    t.string   "crash_class"
    t.string   "bundle_version"
    t.string   "last_crash_at"
    t.string   "app_version_id"
    t.string   "method"
    t.string   "bundle_short_version"
    t.integer  "number_of_crashes"
    t.integer  "line"
    t.boolean  "fixed"
    t.datetime "hockey_updated_at"
    t.datetime "hockey_created_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "crashes", force: :cascade do |t|
    t.integer  "crash_group_id"
    t.integer  "hockey_id"
    t.integer  "hockey_app_id"
    t.integer  "hockey_version_id"
    t.datetime "hockey_created_at"
    t.datetime "hockey_updated_at"
    t.integer  "hockey_crash_group_id"
    t.string   "oem"
    t.string   "model"
    t.integer  "bundle_version"
    t.string   "bundle_short_version"
    t.string   "os_version"
    t.boolean  "jail_break"
    t.string   "contact"
    t.string   "user"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
