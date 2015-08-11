class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :coalescing_panda_users, :login_id, :string
  end
end
