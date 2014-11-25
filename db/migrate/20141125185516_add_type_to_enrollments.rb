class AddTypeToEnrollments < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_enrollments, :type, :string
  end
end
