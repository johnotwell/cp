CoalescingPanda::Engine.routes.draw do
  get '/oauth2/redirect' => 'oauth2#redirect'
  get '/config' => 'lti#lti_config'
  get '/launch' => 'lti#launch'
  get '/styleguide' => 'lti#styleguide'
  get '/start_session' => 'lti#start_session', as: :start_session
end
