class CreateCoalescingPandaAssignments < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_assignments do |t|
      t.belongs_to :coalescing_panda_course, null: false
      t.string :name
      t.string :description
      t.string :canvas_assignment_id, null: false
      t.string :workflow_state
      t.float :points_possible
      t.datetime :due_at
      t.datetime :unlock_at
      t.datetime :lock_at

      t.timestamps
    end

    add_index :coalescing_panda_assignments, [:coalescing_panda_course_id, :canvas_assignment_id], name: :index_assignments_course, unique: true
  end
end
