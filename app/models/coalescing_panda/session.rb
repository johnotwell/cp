module CoalescingPanda
  class Session < ActiveRecord::Base
    attr_accessible :token, :data
    serialize :data, Hash

    def self.create_from_session(session)
      params = {}
      session.keys.each do |key|
        params[key] = session[key]
      end
      token = SecureRandom.hex(10)
      Session.create(token: token, data: params)
      token
    end

    def self.restore_from_token(token, session)
      saved_session = Session.find_by_token(token)
      saved_session.data.each_pair do |key, value|
        session[key] = value
      end
    end
  end
end
