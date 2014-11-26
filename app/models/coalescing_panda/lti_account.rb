module CoalescingPanda
  class LtiAccount < ActiveRecord::Base
    validates :name, :key, uniqueness: true
    validates :name, :key, :secret, presence: true
    has_many :lti_nonces, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::LtiNonce'
    has_many :terms, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::Term'
    has_many :courses, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::Course'
    has_many :users, foreign_key: :coalescing_panda_lti_account_id, class_name: 'CoalescingPanda::User'
    has_many :sections, through: :courses
    has_many :enrollments, through: :sections
    has_many :assignments, through: :courses
    has_many :submissions, through: :assignments

    serialize :settings

    validates :canvas_account_id, presence: true

    def validate_nonce(nonce, timestamp)
      cleanup_nonce
      if timestamp > 15.minutes.ago
        lti_nonces.create(nonce: nonce, timestamp: timestamp).persisted?
      end
    end

    private

    def cleanup_nonce
      lti_nonces.where('timestamp > ?', 15.minutes.ago).delete_all
    end

  end
end
