class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :coalescing_panda_assignments, :coalescing_panda_course_id, name: 'index_assignment_course_id'
    add_index :coalescing_panda_courses, :coalescing_panda_lti_account_id, name: 'index_courses_lti_account_id'
    add_index :coalescing_panda_courses, :coalescing_panda_term_id, name: 'index_courses_term_id'
    add_index :coalescing_panda_sections, :coalescing_panda_course_id, name: 'index_sections_course_id'
    add_index :coalescing_panda_enrollments, :coalescing_panda_user_id, name: 'index_enrollments_user_id'
    add_index :coalescing_panda_enrollments, :coalescing_panda_section_id, name: 'index_enrollments_section_id'
    add_index :coalescing_panda_group_memberships, :coalescing_panda_user_id, name: 'index_memberships_user_id'
    add_index :coalescing_panda_group_memberships, :coalescing_panda_group_id, name: 'index_memberships_group_id'
    add_index :coalescing_panda_submissions, :coalescing_panda_user_id, name: 'index_submissions_user_id'
    add_index :coalescing_panda_submissions, :coalescing_panda_assignment_id, name: 'index_submissions_assignment_id'
    add_index :coalescing_panda_users, :coalescing_panda_lti_account_id, name: 'index_users_lti_account_id'
    add_index :coalescing_panda_terms, :coalescing_panda_lti_account_id, name: 'index_terms_lti_account_id'
  end
end