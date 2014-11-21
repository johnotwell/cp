module CoalescingPanda
  class User < ActiveRecord::Base
    belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiAccount'
    has_many :enrollments, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::Enrollment'
    has_many :submissions, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::Submission'
    has_many :sections, through: :enrollments
    has_many :courses, through: :sections
  end
end