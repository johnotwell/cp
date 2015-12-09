require_dependency "coalescing_panda/application_controller"

module CoalescingPanda
  class Oauth2Controller < ApplicationController

    def oauth2
    end

    def redirect
      if !params[:error] && valid_state_token
        lti_account = LtiAccount.find_by_key(params[:key])
        client_id = lti_account.oauth2_client_id
        client_key = lti_account.oauth2_client_key
        user_id = params[:user_id]
        api_domain = params[:api_domain]
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

    def valid_state_token
      return false unless params['state'].present? && session['state'].present?
      params['state'] == session['state']
    end
  end
end
