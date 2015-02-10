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

ActiveRecord::Schema.define(version: 20150210180516) do

  create_table "coalescing_panda_assignments", force: true do |t|
    t.integer  "coalescing_panda_course_id"
    t.string   "name"
    t.string   "description"
    t.string   "canvas_assignment_id"
    t.string   "sis_id"
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
  end

  add_index "coalescing_panda_assignments", ["canvas_assignment_id"], name: "index_coalescing_panda_assignments_on_canvas_assignment_id"
  add_index "coalescing_panda_assignments", ["coalescing_panda_course_id"], name: "index_assignments_course"
  add_index "coalescing_panda_assignments", ["sis_id"], name: "index_coalescing_panda_assignments_on_sis_id"

  create_table "coalescing_panda_canvas_api_auths", force: true do |t|
    t.string   "user_id"
    t.string   "api_domain"
    t.string   "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_canvas_batches", force: true do |t|
    t.float    "percent_complete", default: 0.0
    t.string   "status"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "context_id"
    t.string   "context_type"
  end

  create_table "coalescing_panda_courses", force: true do |t|
    t.integer  "coalescing_panda_lti_account_id"
    t.integer  "coalescing_panda_term_id"
    t.string   "name"
    t.string   "canvas_course_id"
    t.string   "sis_id"
    t.datetime "start_at"
    t.datetime "conclude_at"
    t.string   "workflow_state"
    t.string   "course_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_courses", ["canvas_course_id"], name: "index_coalescing_panda_courses_on_canvas_course_id"
  add_index "coalescing_panda_courses", ["coalescing_panda_lti_account_id"], name: "index_courses_account"
  add_index "coalescing_panda_courses", ["coalescing_panda_term_id"], name: "index_courses_term"
  add_index "coalescing_panda_courses", ["sis_id"], name: "index_coalescing_panda_courses_on_sis_id"

  create_table "coalescing_panda_enrollments", force: true do |t|
    t.integer  "coalescing_panda_user_id"
    t.integer  "coalescing_panda_section_id"
    t.string   "workflow_state"
    t.string   "sis_id"
    t.string   "canvas_enrollment_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_enrollments", ["canvas_enrollment_id"], name: "index_coalescing_panda_enrollments_on_canvas_enrollment_id"
  add_index "coalescing_panda_enrollments", ["coalescing_panda_user_id", "coalescing_panda_section_id"], name: "index_enrollments_user_and_assignment"
  add_index "coalescing_panda_enrollments", ["sis_id"], name: "index_coalescing_panda_enrollments_on_sis_id"

  create_table "coalescing_panda_group_memberships", force: true do |t|
    t.integer  "coalescing_panda_group_id"
    t.integer  "coalescing_panda_user_id"
    t.string   "canvas_group_membership_id"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_groups", force: true do |t|
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "description"
    t.string   "group_category_id"
    t.string   "canvas_group_id"
    t.string   "name"
    t.integer  "members_count"
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
    t.text     "settings"
    t.string   "canvas_account_id"
  end

  create_table "coalescing_panda_lti_nonces", force: true do |t|
    t.integer  "coalescing_panda_lti_account_id"
    t.string   "nonce"
    t.datetime "timestamp"
  end

  create_table "coalescing_panda_sections", force: true do |t|
    t.integer  "coalescing_panda_course_id"
    t.string   "name"
    t.string   "canvas_section_id"
    t.string   "sis_id"
    t.string   "workflow_state"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_sections", ["canvas_section_id"], name: "index_coalescing_panda_sections_on_canvas_section_id"
  add_index "coalescing_panda_sections", ["coalescing_panda_course_id"], name: "index_coalescing_panda_sections_on_coalescing_panda_course_id"
  add_index "coalescing_panda_sections", ["sis_id"], name: "index_coalescing_panda_sections_on_sis_id"

  create_table "coalescing_panda_sessions", force: true do |t|
    t.string   "token"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coalescing_panda_submissions", force: true do |t|
    t.integer  "coalescing_panda_user_id"
    t.integer  "coalescing_panda_assignment_id"
    t.string   "url"
    t.string   "grade"
    t.string   "score"
    t.datetime "submitted_at"
    t.string   "workflow_state"
    t.string   "canvas_submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_submissions", ["canvas_submission_id"], name: "index_coalescing_panda_submissions_on_canvas_submission_id"
  add_index "coalescing_panda_submissions", ["coalescing_panda_user_id", "coalescing_panda_assignment_id"], name: "index_submissions_user_and_assignment"

  create_table "coalescing_panda_terms", force: true do |t|
    t.integer  "coalescing_panda_lti_account_id"
    t.string   "name"
    t.string   "code"
    t.string   "sis_id"
    t.string   "canvas_term_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_terms", ["canvas_term_id"], name: "index_coalescing_panda_terms_on_canvas_term_id"
  add_index "coalescing_panda_terms", ["sis_id"], name: "index_coalescing_panda_terms_on_sis_id"

  create_table "coalescing_panda_users", force: true do |t|
    t.integer  "coalescing_panda_lti_account_id"
    t.string   "name"
    t.string   "email"
    t.string   "roles"
    t.string   "workflow_state"
    t.string   "sis_id"
    t.string   "canvas_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coalescing_panda_users", ["canvas_user_id"], name: "index_coalescing_panda_users_on_canvas_user_id"
  add_index "coalescing_panda_users", ["coalescing_panda_lti_account_id"], name: "index_users_account"
  add_index "coalescing_panda_users", ["sis_id"], name: "index_coalescing_panda_users_on_sis_id"

  create_table "delayed_jobs", force: true do |t|
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
