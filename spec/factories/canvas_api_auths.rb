FactoryGirl.define do
  factory :canvas_api_auth, class: CoalescingPanda::CanvasApiAuth do
    user_id 'abcd'
    api_domain 'test.example'
    api_token 'token'
    refresh_token 'token'
    expires_at { 1.day.from_now }
  end
end
