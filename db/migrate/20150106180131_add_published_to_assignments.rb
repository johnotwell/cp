class AddPublishedToAssignments < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_assignments, :published, :boolean
  end
end
