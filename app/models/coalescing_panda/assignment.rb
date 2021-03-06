module CoalescingPanda
  class Assignment < ActiveRecord::Base
    belongs_to :course, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Course'
    belongs_to :assignment_group, foreign_key: :coalescing_panda_assignment_group_id, class_name: 'CoalescingPanda::AssignmentGroup'
    belongs_to :group_category, foreign_key: :coalescing_panda_group_category_id, class_name: 'CoalescingPanda::GroupCategory'
    has_many :submissions, foreign_key: :coalescing_panda_assignment_id, class_name: 'CoalescingPanda::Submission', dependent: :destroy

    delegate :account, to: :course

    validates :coalescing_panda_course_id, presence: true
    validates :canvas_assignment_id, presence: true
    serialize :submission_types
  end
end
