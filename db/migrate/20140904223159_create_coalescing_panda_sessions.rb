class CreateCoalescingPandaSessions < ActiveRecord::Migration
  def change
    create_table :coalescing_panda_sessions do |t|
      t.string :token
      t.text :data

      t.timestamps
    end
  end
end
