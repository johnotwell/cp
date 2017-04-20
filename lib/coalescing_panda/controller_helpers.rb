module CoalescingPanda
  module ControllerHelpers
    require 'useragent'

    def canvas_oauth2(*roles)
      return if have_session?
      if lti_authorize!(*roles)
        user_id = params['user_id']
        launch_presentation_return_url = @lti_account.settings[:launch_presentation_return_url] || params['launch_presentation_return_url']
        launch_presentation_return_url = [BearcatUri.new(request.env["HTTP_REFERER"]).prefix, launch_presentation_return_url].join unless launch_presentation_return_url.include?('http')
        uri = BearcatUri.new(launch_presentation_return_url)
        set_session(launch_presentation_return_url)

        api_auth = CanvasApiAuth.find_by('user_id = ? and api_domain = ?', user_id, uri.api_domain)
        if api_auth
          begin
            refresh_token(uri, api_auth) if api_auth.expired?
            @client = Bearcat::Client.new(token: api_auth.api_token, prefix: uri.prefix)
            @client.user_profile 'self'
          rescue Footrest::HttpError::BadRequest, Footrest::HttpError::Unauthorized
            # If we can't retrieve our own user profile, or the token refresh fails, something is awry on the canvas end
            # and we'll need to go through the oauth flow again
            render_oauth2_page uri, user_id
          end
        else
          render_oauth2_page uri, user_id
        end
      end
    end

    def render_oauth2_page(uri, user_id)
      @lti_account = params['oauth_consumer_key'] && LtiAccount.find_by_key(params['oauth_consumer_key'])
      return unless @lti_account

      client_id = @lti_account.oauth2_client_id
      client = Bearcat::Client.new(prefix: uri.prefix)
      state = SecureRandom.hex(32)
      OauthState.create! state_key: state, data: { key: params['oauth_consumer_key'], user_id: user_id, api_domain: uri.api_domain }
      redirect_path = coalescing_panda.oauth2_redirect_path
      redirect_url = [coalescing_panda_url, redirect_path.sub(/^\/lti/, '')].join
      @canvas_url = client.auth_redirect_url(client_id, redirect_url, { state: state })

      #delete the added params so the original oauth sig still works
      @lti_params = params.to_hash
      @lti_params.delete('action')
      @lti_params.delete('controller')
      render 'coalescing_panda/oauth2/oauth2', layout: 'coalescing_panda/application'
    end

    def refresh_token(uri, api_auth)
      refresh_client = Bearcat::Client.new(prefix: uri.prefix)
      refresh_body = refresh_client.retrieve_token(@lti_account.oauth2_client_id, coalescing_panda.oauth2_redirect_url,
        @lti_account.oauth2_client_key, api_auth.refresh_token, 'refresh_token')
      api_auth.update({ api_token: refresh_body['access_token'], expires_at: (Time.now + refresh_body['expires_in']) })
    end

    def check_refresh_token
      return unless session['uri'] && session['user_id'] && session['oauth_consumer_key']
      uri = BearcatUri.new(session['uri'])
      api_auth = CanvasApiAuth.find_by(user_id: session['user_id'], api_domain: uri.api_domain)
      @lti_account = LtiAccount.find_by(key: session['oauth_consumer_key'])
      return if @lti_account.nil? || api_auth.nil? # Not all tools use oauth

      refresh_token(uri, api_auth) if api_auth.expired?
    rescue Footrest::HttpError::BadRequest
      render_oauth2_page uri, session['user_id']
    end

    def set_session(launch_presentation_return_url)
      session['user_id'] = params['user_id']
      session['uri'] = launch_presentation_return_url
      session['lis_person_sourcedid'] = params['lis_person_sourcedid']
      session['oauth_consumer_key'] = params['oauth_consumer_key']
      session['custom_canvas_account_id'] = params['custom_canvas_account_id']
    end

    def have_session?
      if params['tool_consumer_instance_guid'] && session['user_id'] != params['user_id']
        reset_session
        logger.info("resetting session params")
        session['user_id'] = params['user_id']
      end

      if (session['user_id'] && session['uri'])
        uri = BearcatUri.new(session['uri'])
        api_auth = CanvasApiAuth.find_by('user_id = ? and api_domain = ?', session['user_id'], uri.api_domain)
        if api_auth && !api_auth.expired?
          @client = Bearcat::Client.new(token: api_auth.api_token, prefix: uri.prefix)
          @client.user_profile 'self'
        end
      end

      @lti_account = LtiAccount.find_by_key(session['oauth_consumer_key']) if session['oauth_consumer_key']

      !!@client
    rescue Footrest::HttpError::Unauthorized
      false
    end

    def lti_authorize!(*roles)
      authorized = false
      if @lti_account = params['oauth_consumer_key'] && LtiAccount.find_by_key(params['oauth_consumer_key'])
        authentiactor = IMS::LTI::Services::MessageAuthenticator.new(request.original_url, request.request_parameters, @lti_account.secret)
        authorized = authentiactor.valid_signature?
      end
      logger.info 'not authorized on tp valid request' if !authorized
      authorized = authorized && (roles.count == 0 || (roles & lti_roles).count > 0)
      logger.info 'not authorized on roles' if !authorized
      authorized = authorized && @lti_account.validate_nonce(params['oauth_nonce'], DateTime.strptime(params['oauth_timestamp'], '%s'))
      logger.info 'not authorized on nonce' if !authorized
      render :text => 'Invalid Credentials, please contact your Administrator.', :status => :unauthorized unless authorized
      authorized
    end

    def lti_editor_button_response(return_type, return_params)
      valid_return_types = [:image_url, :iframe, :url, :lti_launch_url]
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

    def session_check
      user_agent = UserAgent.parse(request.user_agent) # Uses useragent gem!
      if user_agent.browser == 'Safari' && !request.referrer.include?('sessionless_launch') # we apply the fix..
        return if session[:safari_cookie_fixed] # it is already fixed.. continue
        if params[:safari_cookie_fix].present? # we should be top window and able to set cookies.. so fix the issue :)
          session[:safari_cookie_fixed] = true
          redirect_to params[:return_to]
        else
          # Redirect the top frame to your server..
          query = params.to_query
          render :text => "<script>var referrer = document.referrer; top.window.location='?safari_cookie_fix=true&return_to='.concat(encodeURI(referrer));</script>"
        end
      end
    end

  end
end
