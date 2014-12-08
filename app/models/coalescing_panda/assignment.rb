module CoalescingPanda
  class Assignment < ActiveRecord::Base
    belongs_to :course, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Course'
    has_many :submissions, foreign_key: :coalescing_panda_assignment_id, class_name: 'CoalescingPanda::Submission'

    delegate :account, to: :course

    validates :coalescing_panda_course_id, presence: true
    validates :canvas_assignment_id, presence: true
    serialize :submission_types
  end
end
