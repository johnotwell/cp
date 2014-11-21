class CreateCoalescingPandaCanvasBatches < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_canvas_batches do |t|
      t.float :percent_complete, default: 0.0
      t.string :status
      t.text :message

      t.timestamps
    end
  end
end
