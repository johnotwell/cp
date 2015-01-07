module CoalescingPanda
  class Course < ActiveRecord::Base
    belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiAccount'
    belongs_to :term, foreign_key: :coalescing_panda_term_id, class_name: 'CoalescingPanda::Term'
    has_many :sections, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Section'
    has_many :enrollments, through: :sections
    has_many :assignments, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Assignment'
    has_many :submissions, through: :assignments
    has_many :users, through: :sections, source: :users, class_name: 'CoalescingPanda::User'
    has_many :groups, :as => :context, class_name: 'CoalescingPanda::Group'
    has_many :group_memberships, through: :groups, source: :group_memberships, class_name: 'CoalescingPanda::GroupMembership'

    validates :coalescing_panda_lti_account_id, presence: true
    validates :canvas_course_id, presence: true
  end
end
