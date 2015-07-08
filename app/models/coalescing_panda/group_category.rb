module CoalescingPanda
  class GroupCategory < ActiveRecord::Base
    belongs_to :context, :polymorphic => true
    include SingleTablePolymorphic

    belongs_to :leader, foreign_key: :leader_id, class_name: 'CoalescingPanda::User'
    has_many :groups, foreign_key: :coalescing_panda_group_category_id, class_name: 'CoalescingPanda::Group'
    has_many :assignments, foreign_key: :coalescing_panda_group_category_id, class_name: 'CoalescingPanda::Assignment'
    validates :canvas_group_category_id, presence: true
  end
end
