module CoalescingPanda
  module ControllerHelpers

    def canvas_oauth2
      user_id = params['user_id']
      api_domain = params['custom_canvas_api_domain']

      if token = CanvasApiAuth.where('user_id = ? and api_domain = ?', user_id, api_domain).pluck(:api_token).first
        @client = Bearcat::Client.new(token: token, prefix: ENV['OAUTH_PROTOCOL']+'://'+api_domain)
      else
        client_id = ENV['OAUTH_CLIENT_ID']
        client = Bearcat::Client.new(prefix: 'http://'+api_domain)
        @lti_params = params.to_hash
        @canvas_url = client.auth_redirect_url(client_id,
                                               coalescing_panda.oauth2_redirect_url({key: params['oauth_consumer_key'],
                                               user_id: user_id, api_domain: api_domain}))
        #delete the added params so the original oauth sig still works
        @lti_params.delete('action')
        @lti_params.delete('controller')
        render 'coalescing_panda/oauth2/oauth2'
      end
    end

    def lti_authorize!(*roles)
      authorized = false
      if @lti_account = params['oauth_consumer_key'] && LtiAccount.find_by_key(params['oauth_consumer_key'])
        @tp = IMS::LTI::ToolProvider.new(@lti_account.key, @lti_account.secret, params)
        authorized = @tp.valid_request?(request)
      end
      authorized = authorized && (roles == 0 || (roles && lti_roles).count > 1)
      authorized = authorized && @lti_account.validate_nonce(params['oauth_nonce'], DateTime.strptime(params['oauth_timestamp'],'%s'))
      if !authorized
        render :text => 'Invalid Credentials, please contact your Administrator.', :status => :unauthorized
      end
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

  end
end
