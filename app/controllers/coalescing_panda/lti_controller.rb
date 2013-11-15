require_dependency "coalescing_panda/application_controller"

module CoalescingPanda
  class LtiController < ApplicationController

    def lti_config
      lti_options = CoalescingPanda.lti_options
      lti_nav = CoalescingPanda.lti_paths
      platform = 'canvas.instructure.com'
      host = "#{request.scheme}://#{request.host_with_port}"
      tc = IMS::LTI::ToolConfig.new(:title => lti_options[:title], :launch_url => (lti_options[:launch_url])|| 'ABC')
      tc.set_ext_param(platform, :domain, request.host)
      tc.set_ext_param(platform, :privacy_level, 'public')
      lti_nav.each do |k, v|
        tc.set_ext_param(platform, "#{k.to_s}_navigation".to_sym, ext_params(v) )
      end

      #strip the launch url
      xml = tc.to_xml.sub( /<blti:launch_url>.*<\/blti:launch_url>/, '') if lti_options[:launch_url].blank?
      render :xml => xml
    end

    private

    def ext_params(options)
      url = options.delete(:url)
      options[:url] = main_app.send(url+'_url')
      options
    end

  end
end