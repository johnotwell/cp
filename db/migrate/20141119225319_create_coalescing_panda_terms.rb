class CreateCoalescingPandaTerms < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_terms do |t|
      t.belongs_to :coalescing_panda_lti_account, null: false
      t.string :name
      t.string :code
      t.string :sis_id
      t.string :canvas_term_id, null: false
      t.datetime :start_at
      t.datetime :end_at
      t.string :workflow_state

      t.timestamps
    end

    add_index :coalescing_panda_terms, [:canvas_term_id, :coalescing_panda_lti_account_id], name: :index_terms_account, unique: true
    add_index :coalescing_panda_terms, :sis_id
  end
end
