class CreateCoalescingPandaEnrollments < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_enrollments do |t|
      t.belongs_to :coalescing_panda_user, null: false
      t.belongs_to :coalescing_panda_section, null: false
      t.string :workflow_state
      t.string :sis_id
      t.string :canvas_enrollment_id, null: false
      t.string :enrollment_type
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end

    add_index :coalescing_panda_enrollments, [:coalescing_panda_user_id, :coalescing_panda_section_id, :enrollment_type], name: :index_enrollments_user_and_assignment, unique: true
    add_index :coalescing_panda_enrollments, :sis_id
  end
end
