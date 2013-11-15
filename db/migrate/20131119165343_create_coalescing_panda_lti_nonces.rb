class CreateCoalescingPandaLtiNonces < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_lti_nonces do |t|
      t.belongs_to :coalescing_panda_lti_account
      t.string :nonce
      t.datetime :timestamp
    end
  end
end
