class AddGroupModeratorToGroupMemberships < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_group_memberships, :moderator, :boolean
  end
end
