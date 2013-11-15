Rails.application.routes.draw do

  lti_mount CoalescingPanda::Engine, at: "/lti", lti_options:{title:'LTI Tool'}

end
