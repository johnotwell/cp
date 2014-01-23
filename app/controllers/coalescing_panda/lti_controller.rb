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
      if lti_options.has_key?(:custom_fields)
        tc.set_ext_param(platform, :custom_fields, lti_options[:custom_fields])
        lti_options[:custom_fields].each do |k, v|
          tc.set_ext_param(platform, k, v)
        end
      end

      lti_nav.each do |k, v|
        tc.set_ext_param(platform, setting_name(k.to_s), ext_params(v))
      end

      #strip the launch url
      xml = tc.to_xml.sub(/<blti:launch_url>.*<\/blti:launch_url>/, '') if lti_options[:launch_url].blank?
      render :xml => xml
    end

    def styleguide
      render file: 'coalescing_panda/styleguide/styleguide.html'
    end

    def launch
      render 'coalescing_panda/launch'
    end

    private

    def setting_name(name)
      tail = ''
      if %w(course account user).include?(name)
        tail = '_navigation' unless name.include? '_navigation'
      end
      (name+tail).to_sym
    end

    def ext_params(options)
      url = options.delete(:url)
      options[:url] = main_app.send(url+'_url')
      options
    end

  end
end