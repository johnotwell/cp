module CoalescingPanda
  class ApplicationController < ActionController::Base
    require 'useragent'

    before_filter :session_check

    def session_check
      user_agent = UserAgent.parse(request.user_agent) # Uses useragent gem!
      if user_agent.browser == 'Safari' # we apply the fix..
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
