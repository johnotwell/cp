module CoalescingPanda
  class LtiNonce < ActiveRecord::Base
    validates :coalescing_panda_lti_account, :nonce, :timestamp, :presence => true
    validates :nonce, uniqueness: {scope: :coalescing_panda_lti_account}
    belongs_to :coalescing_panda_lti_account, :class_name => 'CoalescingPanda::LtiAccount'
  end

  def cleanup
    CoalescingPanda::LtiNonce.where("coalescing_panda_lti_account_id = ? AND timestamp < ?", b.coalescing_panda_lti_account.id, 15.minutes.ago)
  end

end
