class CreateCoalescingPandaCanvasApiAuths < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_canvas_api_auths do |t|
      t.string :user_id
      t.string :api_domain
      t.string :api_token
      t.timestamps
    end
  end
end
