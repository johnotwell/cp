class AddOptionToCanvasBatches < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_canvas_batches, :options, :text
  end
end
