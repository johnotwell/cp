module CoalescingPanda
  class Term < ActiveRecord::Base
    belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiAccount'
    has_many :courses, foreign_key: :coalescing_panda_term_id, class_name: 'CoalescingPanda::Course'
  end
end
