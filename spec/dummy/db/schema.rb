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

ActiveRecord::Schema.define(version: 20160830183155) do

  create_table "coalescing_panda_assignment_groups", force: :cascade do |t|
    t.integer  "coalescing_panda_course_id", null: false
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "canvas_assignment_group_id"
    t.string   "name"
    t.integer  "position"
    t.float    "group_weight"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_assignment_groups", ["canvas_assignment_group_id", "context_id", "context_type"], name: "index_assignment_group_context", unique: true
  add_index "coalescing_panda_assignment_groups", ["coalescing_panda_course_id", "canvas_assignment_group_id"], name: "index_assignment_group_course", unique: true

  create_table "coalescing_panda_assignments", force: :cascade do |t|
    t.integer  "coalescing_panda_course_id",           null: false
    t.string   "name"
    t.text     "description"
    t.string   "canvas_assignment_id",                 null: false
    t.string   "workflow_state"
    t.float    "points_possible"
    t.datetime "due_at"
    t.datetime "unlock_at"
    t.datetime "lock_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "submission_types"
    t.integer  "group_category_id"
    t.boolean  "grade_group_students_individually"
    t.boolean  "published"
    t.integer  "coalescing_panda_assignment_group_id"
    t.integer  "coalescing_panda_group_category_id"
  end

  add_index "coalescing_panda_assignments", ["coalescing_panda_course_id", "canvas_assignment_id"], name: "index_assignments_course", unique: true

  create_table "coalescing_panda_canvas_api_auths", force: :cascade do |t|
    t.string   "user_id"
    t.string   "api_domain"
    t.string   "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "refresh_token"
    t.datetime "expires_at"
  end

  create_table "coalescing_panda_canvas_batches", force: :cascade do |t|
    t.float    "percent_complete",                default: 0.0
    t.string   "status"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "context_id"
    t.string   "context_type"
    t.integer  "coalescing_panda_lti_account_id"
    t.text     "options"
  end

  create_table "coalescing_panda_courses", force: :cascade do |t|
    t.integer  "coalescing_panda_lti_account_id", null: false
    t.integer  "coalescing_panda_term_id"
    t.string   "name"
    t.string   "canvas_course_id",                null: false
    t.string   "sis_id"
    t.datetime "start_at"
    t.datetime "conclude_at"
    t.string   "workflow_state"
    t.string   "course_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_courses", ["coalescing_panda_lti_account_id", "canvas_course_id"], name: "index_courses_account", unique: true
  add_index "coalescing_panda_courses", ["coalescing_panda_term_id", "canvas_course_id"], name: "index_courses_term", unique: true
  add_index "coalescing_panda_courses", ["sis_id"], name: "index_coalescing_panda_courses_on_sis_id"

  create_table "coalescing_panda_enrollments", force: :cascade do |t|
    t.integer  "coalescing_panda_user_id",    null: false
    t.integer  "coalescing_panda_section_id", null: false
    t.string   "workflow_state"
    t.string   "sis_id"
    t.string   "canvas_enrollment_id",        null: false
    t.string   "enrollment_type"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_enrollments", ["coalescing_panda_user_id", "coalescing_panda_section_id", "enrollment_type"], name: "index_enrollments_user_and_section", unique: true
  add_index "coalescing_panda_enrollments", ["sis_id"], name: "index_coalescing_panda_enrollments_on_sis_id"

  create_table "coalescing_panda_group_categories", force: :cascade do |t|
    t.integer  "context_id"
    t.string   "context_type"
    t.integer  "canvas_group_category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_group_categories", ["context_id", "context_type"], name: "index_group_categories_context_and_context_type"

  create_table "coalescing_panda_group_memberships", force: :cascade do |t|
    t.integer  "coalescing_panda_group_id"
    t.integer  "coalescing_panda_user_id"
    t.string   "canvas_group_membership_id"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "moderator"
  end

  add_index "coalescing_panda_group_memberships", ["coalescing_panda_group_id", "coalescing_panda_user_id"], name: "index_group_memberships_user_and_group", unique: true

  create_table "coalescing_panda_groups", force: :cascade do |t|
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "description"
    t.string   "group_category_id"
    t.string   "canvas_group_id"
    t.string   "name"
    t.integer  "members_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "leader_id"
    t.integer  "coalescing_panda_group_category_id"
  end

  add_index "coalescing_panda_groups", ["context_id", "canvas_group_id"], name: "index_groups_context_and_group_id", unique: true

  create_table "coalescing_panda_lti_accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "key"
    t.string   "secret"
    t.string   "oauth2_client_id"
    t.string   "oauth2_client_key"
    t.string   "canvas_account_id"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_lti_nonces", force: :cascade do |t|
    t.integer  "coalescing_panda_lti_account_id"
    t.string   "nonce"
    t.datetime "timestamp"
  end

  create_table "coalescing_panda_oauth_states", force: :cascade do |t|
    t.string   "state_key"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_oauth_states", ["state_key"], name: "index_coalescing_panda_oauth_states_on_state_key", unique: true

  create_table "coalescing_panda_sections", force: :cascade do |t|
    t.integer  "coalescing_panda_course_id", null: false
    t.string   "name"
    t.string   "canvas_section_id",          null: false
    t.string   "sis_id"
    t.string   "workflow_state"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_sections", ["coalescing_panda_course_id", "canvas_section_id"], name: "index_sections_course", unique: true
  add_index "coalescing_panda_sections", ["sis_id"], name: "index_coalescing_panda_sections_on_sis_id"

  create_table "coalescing_panda_sessions", force: :cascade do |t|
    t.string   "token"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_submissions", force: :cascade do |t|
    t.integer  "coalescing_panda_user_id",       null: false
    t.integer  "coalescing_panda_assignment_id", null: false
    t.string   "url"
    t.string   "grade"
    t.string   "score"
    t.datetime "submitted_at"
    t.string   "workflow_state"
    t.string   "canvas_submission_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_submissions", ["canvas_submission_id"], name: "index_coalescing_panda_submissions_on_canvas_submission_id"
  add_index "coalescing_panda_submissions", ["coalescing_panda_user_id", "coalescing_panda_assignment_id", "canvas_submission_id"], name: "index_submissions_user_and_assignment", unique: true

  create_table "coalescing_panda_terms", force: :cascade do |t|
    t.integer  "coalescing_panda_lti_account_id", null: false
    t.string   "name"
    t.string   "code"
    t.string   "sis_id"
    t.string   "canvas_term_id",                  null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_terms", ["canvas_term_id", "coalescing_panda_lti_account_id"], name: "index_terms_account", unique: true
  add_index "coalescing_panda_terms", ["sis_id"], name: "index_coalescing_panda_terms_on_sis_id"

  create_table "coalescing_panda_users", force: :cascade do |t|
    t.integer  "coalescing_panda_lti_account_id", null: false
    t.string   "name"
    t.string   "email"
    t.string   "roles"
    t.string   "workflow_state"
    t.string   "sis_id"
    t.string   "canvas_user_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login_id"
  end

  add_index "coalescing_panda_users", ["coalescing_panda_lti_account_id", "canvas_user_id"], name: "index_users_account", unique: true
  add_index "coalescing_panda_users", ["sis_id"], name: "index_coalescing_panda_users_on_sis_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

end
