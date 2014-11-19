class CreateCoalescingPandaCourses < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_courses do |t|
      t.belongs_to :coalescing_panda_lti_account
      t.belongs_to :coalescing_panda_term
      t.string :name
      t.string :canvas_course_id
      t.string :sis_id
      t.datetime :start_at
      t.datetime :conclude_at
      t.string :workflow_state
      t.string :course_code

      t.timestamps
    end

    add_index :coalescing_panda_courses, :coalescing_panda_lti_account_id, name: :index_courses_account
    add_index :coalescing_panda_courses, :coalescing_panda_term_id, name: :index_courses_term
    add_index :coalescing_panda_courses, :canvas_course_id
    add_index :coalescing_panda_courses, :sis_id
  end
end
