module CoalescingPanda
  class Submission < ActiveRecord::Base
    belongs_to :user, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::User'
    belongs_to :assignment, foreign_key: :coalescing_panda_assignment_id, class_name: 'CoalescingPanda::Assignment'

    delegate :account, to: :assignment

    validates :coalescing_panda_user_id, presence: true
    validates :coalescing_panda_assignment_id, presence: true
    validates :canvas_submission_id, presence: true
  end
end
