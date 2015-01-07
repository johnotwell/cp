class CreateCoalescingPandaGroups < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_groups do |t|
      t.belongs_to :context, polymorphic: true
      t.string :description
      t.string :group_category_id
      t.string :canvas_group_id
      t.string :name
      t.integer :members_count

      t.timestamps
    end
    add_index :coalescing_panda_groups, [:context_id, :canvas_group_id], name: :index_groups_context_and_group_id, unique: true
  end
end
