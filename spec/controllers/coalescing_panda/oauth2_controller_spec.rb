require 'spec_helper'

describe CoalescingPanda::Oauth2Controller do
  routes { CoalescingPanda::Engine.routes }

  describe "#redirect" do
    it 'creates a token in the db' do
      ENV['OAUTH_PROTOCOL'] = 'http'
      Bearcat::Client.any_instance.stub(retrieve_token: 'foobar')
      get :redirect, {user_id: 1, api_domain:'foo.com', code:'bar'}
      auth = CoalescingPanda::CanvasApiAuth.find_by_user_id_and_api_domain(1, 'foo.com')
      auth.should_not == nil
    end

    it "doesn't create a token in the db" do
      get :redirect, {error: 'your face'}
      CoalescingPanda::CanvasApiAuth.all.count.should == 0
    end

  end

end