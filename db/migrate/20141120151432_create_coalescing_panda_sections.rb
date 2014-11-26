class CreateCoalescingPandaSections < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_sections do |t|
      t.belongs_to :coalescing_panda_course, null: false
      t.string :name
      t.string :canvas_section_id, null: false
      t.string :sis_id
      t.string :workflow_state
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end

    add_index :coalescing_panda_sections, [:coalescing_panda_course_id, :canvas_section_id], name: :index_sections_course, unique: true
    add_index :coalescing_panda_sections, :sis_id
  end
end
