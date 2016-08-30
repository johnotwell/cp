class CreateCoalescingPandaOauthStates < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_oauth_states do |t|
      t.string :state_key
      t.text :data

      t.timestamps
    end
    add_index :coalescing_panda_oauth_states, :state_key, unique: true
  end
end
