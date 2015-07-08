class CreateCoalescingPandaGroupCategories < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_group_categories do |t|
      t.belongs_to :context, polymorphic: true
      t.string :context_type
      t.integer :canvas_group_category_id
      t.string :name

      t.timestamps
    end
    add_index :coalescing_panda_group_categories, [:context_id, :context_type], name: :index_group_categories_context_and_context_type

    add_column :coalescing_panda_assignments, :coalescing_panda_group_category_id, :integer
    add_column :coalescing_panda_groups, :coalescing_panda_group_category_id, :integer
  end
end
