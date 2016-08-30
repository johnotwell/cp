module CoalescingPanda
  class OauthState < ActiveRecord::Base
    serialize :data, Hash
    validates :state_key, presence: true, uniqueness: true
  end
end
