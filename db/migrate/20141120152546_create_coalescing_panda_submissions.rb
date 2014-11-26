class CreateCoalescingPandaSubmissions < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_submissions do |t|
      t.belongs_to :coalescing_panda_user, null: false
      t.belongs_to :coalescing_panda_assignment, null: false
      t.string :url
      t.string :grade
      t.string :score
      t.datetime :submitted_at
      t.string :workflow_state
      t.string :canvas_submission_id, null: false

      t.timestamps
    end

    add_index :coalescing_panda_submissions, [:coalescing_panda_user_id, :coalescing_panda_assignment_id, :canvas_submission_id], name: :index_submissions_user_and_assignment, unique: true
    add_index :coalescing_panda_submissions, :canvas_submission_id
  end
end
