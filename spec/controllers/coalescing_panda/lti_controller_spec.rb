require 'spec_helper'

describe CoalescingPanda::LtiController, :type => :controller do
  routes { CoalescingPanda::Engine.routes }

  describe '#lti_config' do
    before :each do
      CoalescingPanda.class_variable_set(:@@lti_navigation, {})
      CoalescingPanda.lti_environments = { test_domain: 'test' }
    end

    it 'generates lti xml config'do
      get(:lti_config)
      xml = Nokogiri::XML(response.body)
      xml.at_xpath('//blti:title').text.should == 'LTI Tool'
      xml.at_xpath('//lticm:property[@name="domain"]').text.should_not == nil
      xml.at_xpath('//lticm:property[@name="privacy_level"]').text.should == 'public'
    end

    it 'generates lti nav config' do
      pending('cannot figure out why url: "test" is not working.')
      CoalescingPanda.stage_navigation(:account, {
        url: 'launch',
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

    it 'includes environment information' do
      get(:lti_config)
      xml = Nokogiri::XML(response.body)
      environments = xml.at_xpath('//lticm:options[@name="environments"]')
      environments.at_xpath('lticm:property[@name="test_domain"]').text.should == 'test'
    end

  end
end
