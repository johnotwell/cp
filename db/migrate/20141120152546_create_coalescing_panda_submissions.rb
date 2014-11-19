class CreateCoalescingPandaSubmissions < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_submissions do |t|
      t.belongs_to :coalescing_panda_user
      t.belongs_to :coalescing_panda_assignment
      t.string :url
      t.string :grade
      t.string :score
      t.datetime :submitted_at
      t.string :workflow_state
      t.string :canvas_submission_id

      t.timestamps
    end

    add_index :coalescing_panda_submissions, [:coalescing_panda_user_id, :coalescing_panda_assignment_id], name: :index_submissions_user_and_assignment
    add_index :coalescing_panda_submissions, :canvas_submission_id
  end
end
