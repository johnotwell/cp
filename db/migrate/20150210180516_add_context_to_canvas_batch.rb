class AddContextToCanvasBatch < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_canvas_batches, :context_id, :integer
    add_column :coalescing_panda_canvas_batches, :context_type, :string
  end
end
