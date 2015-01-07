module CoalescingPanda
  class Group < ActiveRecord::Base
    belongs_to :context, :polymorphic => true
    include SingleTablePolymorphic

    has_many :group_memberships, dependent: :destroy, foreign_key: :coalescing_panda_group_id, class_name: 'CoalescingPanda::GroupMembership'
    validates :group_category_id, presence: true
    validates :canvas_group_id, presence: true
    validates :coalescing_panda_user_id, presence: true
  end
end
