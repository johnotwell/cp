class Account < CoalescingPanda::LtiAccount
  has_many :terms, foreign_key: :coalescing_panda_lti_account_id, class_name: 'Term'
  has_many :courses, foreign_key: :coalescing_panda_lti_account_id, class_name: 'Course'
  has_many :users, foreign_key: :coalescing_panda_lti_account_id, class_name: 'User'
end
