class CreateCoalescingPandaGroupMemberships < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_group_memberships do |t|
      t.belongs_to :coalescing_panda_group
      t.belongs_to :coalescing_panda_user
      t.string :canvas_group_membership_id
      t.string :workflow_state

      t.timestamps
    end
    add_index :coalescing_panda_group_memberships, [:coalescing_panda_group_id, :coalescing_panda_user_id], name: :index_group_memberships_user_and_group, unique: true
  end
end
