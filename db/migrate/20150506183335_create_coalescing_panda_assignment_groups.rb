class CreateCoalescingPandaAssignmentGroups < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_assignment_groups do |t|
      t.belongs_to :coalescing_panda_course, null: false
      t.belongs_to :context, polymorphic: true
      t.string :canvas_assignment_group_id
      t.string :name
      t.integer :position
      t.float :group_weight
      t.string :workflow_state

      t.timestamps
    end

    add_index :coalescing_panda_assignment_groups, [:coalescing_panda_course_id, :canvas_assignment_group_id], name: :index_assignment_group_course, unique: true
    add_index :coalescing_panda_assignment_groups, [:canvas_assignment_group_id, :context_id, :context_type], name: :index_assignment_group_context, unique: true
  end
end
