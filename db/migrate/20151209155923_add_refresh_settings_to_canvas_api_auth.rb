class AddRefreshSettingsToCanvasApiAuth < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_canvas_api_auths, :refresh_token, :string
    add_column :coalescing_panda_canvas_api_auths, :expires_at, :datetime
  end
end
