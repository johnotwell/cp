class AddGroupCategoryIdToAssignment < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_assignments, :group_category_id, :integer
    add_column :coalescing_panda_assignments, :grade_group_students_individually, :boolean
  end
end
