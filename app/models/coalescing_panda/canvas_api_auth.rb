module CoalescingPanda
  class CanvasApiAuth < ActiveRecord::Base
    validates :user_id, :api_domain, presence: true
    validates :user_id, uniqueness: {scope: :api_domain}
  end

end
