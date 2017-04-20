require_dependency "coalescing_panda/application_controller"

module CoalescingPanda
  class LtiController < ApplicationController

    def lti_config
      lti_options = CoalescingPanda.lti_options
      lti_nav = CoalescingPanda.lti_paths
      lti_environments = CoalescingPanda.lti_environments

      if lti_environments.empty?
        render text: 'Domains must be set in lti_environments'
        return
      end

      lti_nav[:course][:text] = params[:course_navigation_label] if params[:course_navigation_label].present?
      lti_nav[:account][:text] = params[:account_navigation_label] if params[:account_navigation_label].present?
      platform = 'canvas.instructure.com'
      host = "#{request.scheme}://#{request.host_with_port}"
      tc = IMS::LTI::Services::ToolConfig.new(:title => lti_options[:title], :launch_url => ("#{host}#{lti_options[:launch_route]}") || 'ABC')
      tc.set_ext_param(platform, :domain, request.host)
      tc.set_ext_param(platform, :privacy_level, 'public')
      tc.set_custom_param(:custom_canvas_role, '$Canvas.membership.roles')
      if lti_options.has_key?(:custom_fields)
        tc.set_ext_param(platform, :custom_fields, lti_options[:custom_fields])
        lti_options[:custom_fields].each do |k, v|
          tc.set_ext_param(platform, k, v)
        end
      end

      lti_nav.each do |k, v|
        tc.set_ext_param(platform, setting_name(k.to_s), ext_params(v))
      end

      tc.set_ext_param(platform, :environments, lti_environments)

      #strip the launch url
      xml = tc.to_xml
      xml = xml.sub(/<blti:launch_url>.*<\/blti:launch_url>/, '') if lti_options[:launch_route].blank?
      render :xml => xml
    end

    def styleguide
      render file: 'coalescing_panda/styleguide/styleguide.html'
    end

    def launch
      render 'coalescing_panda/launch'
    end

    def start_session
      session['started'] = true
      redirect_to CGI::unescape(params['referer'])
    end

    private

    def setting_name(name)
      tail = ''
      if %w(course account user).include?(name)
        tail = '_navigation' unless name.include? '_navigation'
      end
      ([name, tail].join).to_sym
    end

    def ext_params(options)
      url = options.delete(:url)
      options[:url] = main_app.send([url,'_url'].join)
      options
    end

  end
end
