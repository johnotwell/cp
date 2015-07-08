class AddLeaderIdToGroups < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_groups, :leader_id, :integer
    add_foreign_key :coalescing_panda_groups, :coalescing_panda_users, column: :leader_id, primary_key: "id"
  end
end
