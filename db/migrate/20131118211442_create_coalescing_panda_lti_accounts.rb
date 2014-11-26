class CreateCoalescingPandaLtiAccounts < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_lti_accounts do |t|
      t.string :name
      t.string :key
      t.string :secret
      t.string :oauth2_client_id
      t.string :oauth2_client_key
      t.string :canvas_account_id
      t.text :settings

      t.timestamps
    end
  end
end
