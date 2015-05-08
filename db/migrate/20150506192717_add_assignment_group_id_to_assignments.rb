class AddAssignmentGroupIdToAssignments < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_assignments, :coalescing_panda_assignment_group_id, :integer
  end
end
