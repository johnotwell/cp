Rails.application.routes.draw do

  mount CoalescingPanda::Engine, at: "/lti", lti_options:{title:'LTI Tool'}

end
