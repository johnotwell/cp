CoalescingPanda::Engine.routes.draw do
  resources :canvas_batches, only: [:show]
  post '/canvas_batches/clear_batch_session', as: :clear_batch_session

  get '/oauth2/redirect' => 'oauth2#redirect'
  get '/config' => 'lti#lti_config'
  get '/launch' => 'lti#launch'
  get '/styleguide' => 'lti#styleguide'
  get '/start_session' => 'lti#start_session', as: :start_session
end
