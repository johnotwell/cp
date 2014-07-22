class AddSettingsToCoalescingPandaLtiAccount < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_lti_accounts, :settings, :text
  end
end
