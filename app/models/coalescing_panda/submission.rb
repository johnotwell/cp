module CoalescingPanda
  class Submission < ActiveRecord::Base
    belongs_to :user, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::User'
    belongs_to :assignment, foreign_key: :coalescing_panda_assignment_id, class_name: 'CoalescingPanda::Assignment'

    delegate :account, to: :assignment
  end
end
