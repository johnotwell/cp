module CoalescingPanda
  class Section < ActiveRecord::Base
    belongs_to :course, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Course'
    has_many :enrollments, foreign_key: :coalescing_panda_section_id, class_name: 'CoalescingPanda::Enrollment'
    has_many :users, through: :enrollments, class_name: 'CoalescingPanda::User'

    delegate :account, to: :course
  end
end
