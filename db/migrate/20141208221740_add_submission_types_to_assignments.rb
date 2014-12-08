class AddSubmissionTypesToAssignments < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_assignments, :submission_types, :text
  end
end
