module CoalescingPanda
  class User < ActiveRecord::Base
    belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiAccount'
    has_many :enrollments, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::Enrollment', dependent: :destroy
    has_many :submissions, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::Submission', dependent: :destroy
    has_many :sections, through: :enrollments
    has_many :courses, through: :sections

    store :roles

    validates :coalescing_panda_lti_account_id, presence: true
    validates :canvas_user_id, presence: true
  end
end
