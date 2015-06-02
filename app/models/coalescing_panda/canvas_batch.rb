module CoalescingPanda
  class CanvasBatch < ActiveRecord::Base
    serialize :options

    belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiAccount'
    belongs_to :context, polymorphic: true

    default_scope { order('created_at DESC') }
  end
end
