class CreateCoalescingPandaUsers < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_users do |t|
      t.belongs_to :coalescing_panda_lti_account
      t.string :name
      t.string :email
      t.string :roles
      t.string :workflow_state
      t.string :sis_id
      t.string :canvas_user_id

      t.timestamps
    end

    add_index :coalescing_panda_users, :coalescing_panda_lti_account_id, name: :index_users_account
    add_index :coalescing_panda_users, :canvas_user_id
    add_index :coalescing_panda_users, :sis_id
  end
end
