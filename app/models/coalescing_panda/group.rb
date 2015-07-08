module CoalescingPanda
  class Group < ActiveRecord::Base
    belongs_to :context, :polymorphic => true
    include SingleTablePolymorphic

    belongs_to :leader, foreign_key: :leader_id, class_name: 'CoalescingPanda::User'
    belongs_to :group_category, foreign_key: :coalescing_panda_group_category_id, class_name: 'CoalescingPanda::GroupCategory'
    has_many :group_memberships, foreign_key: :coalescing_panda_group_id, class_name: 'CoalescingPanda::GroupMembership', dependent: :destroy
    validates :group_category_id, presence: true
    validates :canvas_group_id, presence: true
  end
end
