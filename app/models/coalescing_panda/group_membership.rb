module CoalescingPanda
  class GroupMembership < ActiveRecord::Base
    belongs_to :user, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::User'
    belongs_to :group, foreign_key: :coalescing_panda_group_id, class_name: 'CoalescingPanda::Group'
    validates :canvas_group_membership_id, presence: true
  end
end
