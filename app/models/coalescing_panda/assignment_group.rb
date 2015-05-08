module CoalescingPanda
  class AssignmentGroup < ActiveRecord::Base
    belongs_to :course, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Course'
    has_many :assignments, foreign_key: :coalescing_panda_assignment_group_id, class_name: 'CoalescingPanda::Assignment', dependent: :destroy

    delegate :account, to: :course

    validates :coalescing_panda_course_id, presence: true
    validates :canvas_assignment_group_id, presence: true
  end
end
