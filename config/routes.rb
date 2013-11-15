CoalescingPanda::Engine.routes.draw do
  get '/oauth2/redirect' => 'oauth2#redirect'
  get '/config' => 'lti#lti_config'
end
