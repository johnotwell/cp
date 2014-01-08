require 'spec_helper'

describe CoalescingPanda::LtiController do
  routes { CoalescingPanda::Engine.routes }

  describe '#lti_config' do

    it 'generates lti xml config'do
      controller.main_app.stub(:test_action_url) {'foo'}
      get(:lti_config)
      xml = Nokogiri::XML(response.body)
      xml.at_xpath('//blti:title').text.should == 'LTI Tool'
      xml.at_xpath('//lticm:property[@name="domain"]').text.should_not == nil
      xml.at_xpath('//lticm:property[@name="privacy_level"]').text.should == 'public'
    end

    it 'generates lti nav config' do
      controller.main_app.stub(:test_action_url) {'foo'}
      CoalescingPanda.stage_navigation(:account, {
        url: 'test_action',
        text: 'My Title',
        enabled: false
      })
      CoalescingPanda.register_navigation(:account)
      CoalescingPanda.propagate_lti_navigation
      get(:lti_config)
      xml = Nokogiri::XML(response.body)
      account_nav = xml.at_xpath('//lticm:options[@name="account_navigation"]')
      account_nav.at_xpath('lticm:property[@name="enabled"]').text.should == 'false'
      account_nav.at_xpath('lticm:property[@name="text"]').text.should == 'My Title'
      account_nav.at_xpath('lticm:property[@name="url"]').text.should == 'foo'
    end

  end


  it 'get the url, from the action string' do
    controller.main_app.stub(:test_action_url) {'foo'}
    options = controller.send(:ext_params, {url:'test_action'})
    options[:url].should == 'foo'
  end


end