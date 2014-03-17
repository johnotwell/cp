module CoalescingPanda
  module ControllerHelpers

    def canvas_oauth2(*roles)
      return if have_session?
      if lti_authorize!(*roles)
        user_id = params['user_id']
        uri = URI.parse(params['launch_presentation_return_url'])
        api_domain = uri.host
        api_domain = "#{api_domain}:#{uri.port.to_s}" if uri.port
        scheme = uri.scheme + '://'
        @lti_params = params.to_hash
        session['user_id'] = user_id
        session['uri'] = params['launch_presentation_return_url']
        session['lis_person_sourcedid'] = @lti_params['lis_person_sourcedid']

        if token = CanvasApiAuth.where('user_id = ? and api_domain = ?', user_id, api_domain).pluck(:api_token).first
          @client = Bearcat::Client.new(token: token, prefix: scheme+api_domain)
        elsif @lti_account = params['oauth_consumer_key'] && LtiAccount.find_by_key(params['oauth_consumer_key'])
          client_id = @lti_account.oauth2_client_id
          client = Bearcat::Client.new(prefix: scheme+api_domain)

          @canvas_url = client.auth_redirect_url(client_id,
                                                 coalescing_panda.oauth2_redirect_url({key: params['oauth_consumer_key'],
                                                                                       user_id: user_id, api_domain: api_domain}))
          #delete the added params so the original oauth sig still works
          @lti_params.delete('action')
          @lti_params.delete('controller')
          render 'coalescing_panda/oauth2/oauth2'
        end
      end
    end

    def have_session?
      #if this is a new lti launch flush the session
      if params['tool_consumer_instance_guid']
        reset_session
        logger.info("resetting session params")
      end
      if (session['user_id'] && session['uri'])
        uri = URI.parse(session['uri'])
        api_domain = uri.host
        api_domain = "#{api_domain}:#{uri.port.to_s}" if uri.port
        scheme = uri.scheme + '://'
        token = CanvasApiAuth.where('user_id = ? and api_domain = ?', session['user_id'], api_domain).pluck(:api_token).first
        @client = Bearcat::Client.new(token: token, prefix: scheme+api_domain) if token
      end
      !!@client
    end

    def lti_authorize!(*roles)
      authorized = false
      if @lti_account = params['oauth_consumer_key'] && LtiAccount.find_by_key(params['oauth_consumer_key'])
        @tp = IMS::LTI::ToolProvider.new(@lti_account.key, @lti_account.secret, params)
        authorized = @tp.valid_request?(request)
      end
      authorized = authorized && (roles.count == 0 || (roles & lti_roles).count > 0)
      authorized = authorized && @lti_account.validate_nonce(params['oauth_nonce'], DateTime.strptime(params['oauth_timestamp'], '%s'))
      if !authorized
        render :text => 'Invalid Credentials, please contact your Administrator.', :status => :unauthorized
      end
      authorized
    end

    def lti_editor_button_response(return_type, return_params)
      valid_return_types = [:image_url, :iframe, :url]
      raise "invalid editor button return type #{return_type}" unless valid_return_types.include?(return_type)
      return_params[:return_type] = return_type.to_s
      return_url = "#{params['launch_presentation_return_url']}?#{return_params.to_query}"
      redirect_to return_url
    end

    def lti_roles
      @lti_roles ||= params['roles'].split(',').map { |role|
        case role.downcase.strip
          when 'admin'
            :admin
          when 'urn:lti:instrole:ims/lis/administrator'
            :admin
          when 'learner'
            :student
          when 'instructor'
            :teacher
          when 'urn:lti:role:ims/lis/teachingassistant'
            :ta
          when 'contentdeveloper'
            :designer
          when 'urn:lti:instrole:ims/lis/observer'
            :observer
          else
            :none
        end
      }.uniq
    end

    def canvas_environment
      case params['custom_test_environment']
        when 'true'
          :test
        else
          :production
      end
    end

  end
end
