module CoalescingPanda
  class Course < ActiveRecord::Base
    belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiAccount'
    belongs_to :term, foreign_key: :coalescing_panda_term_id, class_name: 'CoalescingPanda::Term'
    has_many :sections, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Section', dependent: :destroy
    has_many :enrollments, through: :sections, dependent: :destroy
    has_many :assignments, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::Assignment', dependent: :destroy
    has_many :submissions, through: :assignments, dependent: :destroy
    has_many :users, through: :sections, source: :users, class_name: 'CoalescingPanda::User'
    has_many :groups, :as => :context, class_name: 'CoalescingPanda::Group', dependent: :destroy
    has_many :group_categories, :as => :context, class_name: 'CoalescingPanda::GroupCategory', dependent: :destroy
    has_many :group_memberships, through: :groups, source: :group_memberships, class_name: 'CoalescingPanda::GroupMembership', dependent: :destroy
    has_many :canvas_batches, as: :context, dependent: :destroy
    has_many :assignment_groups, foreign_key: :coalescing_panda_course_id, class_name: 'CoalescingPanda::AssignmentGroup', dependent: :destroy

    validates :coalescing_panda_lti_account_id, presence: true
    validates :canvas_course_id, presence: true
  end
end
