module CoalescingPanda
  class CanvasApiAuth < ActiveRecord::Base
    validates :user_id, :api_domain, presence: true
    validates :user_id, uniqueness: {scope: :api_domain}

    def expired?
      expires_at && expires_at < Time.now
    end
  end

end
