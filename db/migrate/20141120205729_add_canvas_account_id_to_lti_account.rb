class AddCanvasAccountIdToLtiAccount < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_lti_accounts, :canvas_account_id, :string
  end
end
