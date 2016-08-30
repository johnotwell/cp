require_dependency "coalescing_panda/application_controller"

module CoalescingPanda
  class Oauth2Controller < ApplicationController

    def oauth2
    end

    def redirect
      if !params[:error] && retrieve_oauth_state
        lti_account = LtiAccount.find_by_key(@oauth_state.data[:key])
        client_id = lti_account.oauth2_client_id
        client_key = lti_account.oauth2_client_key
        user_id = @oauth_state.data[:user_id]
        api_domain = @oauth_state.data[:api_domain]
        @oauth_state.destroy
        prefix = [oauth2_protocol, '://', api_domain].join
        Rails.logger.info "Creating Bearcat client for auth token retrieval pointed to: #{prefix}"
        client = Bearcat::Client.new(prefix: prefix)
        token_body = client.retrieve_token(client_id, coalescing_panda.oauth2_redirect_url, client_key, params['code'])
        auth = CanvasApiAuth.where('user_id = ? and api_domain = ?', user_id, api_domain).first_or_initialize
        auth.api_token = token_body['access_token']
        auth.refresh_token = token_body['refresh_token']
        auth.expires_at = Time.now + token_body['expires_in'] if token_body['expires_in']
        auth.user_id = user_id
        auth.api_domain = api_domain
        auth.save!
      end
    end


    private

    def oauth2_protocol
      ENV['OAUTH_PROTOCOL'] || 'https'
    end

    def retrieve_oauth_state
      @oauth_state ||= params[:state].present? && OauthState.find_by(state_key: params[:state])
    end

    def valid_state_token
      return false unless params['state'].present? && session['state'].present?
      params['state'] == session['state']
    end
  end
end
