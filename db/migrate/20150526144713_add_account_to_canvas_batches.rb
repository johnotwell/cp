class AddAccountToCanvasBatches < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_canvas_batches, :coalescing_panda_lti_account_id, :integer, index: true
  end
end
