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

ActiveRecord::Schema.define(version: 20131119165343) do

  create_table "coalescing_panda_canvas_api_auths", force: true do |t|
    t.string   "user_id"
    t.string   "api_domain"
    t.string   "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_lti_accounts", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "secret"
    t.string   "oauth2_client_id"
    t.string   "oauth2_client_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_lti_nonces", force: true do |t|
    t.integer  "coalescing_panda_lti_account_id"
    t.string   "nonce"
    t.datetime "timestamp"
  end

end
