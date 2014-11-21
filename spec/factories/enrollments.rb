FactoryGirl.define do
  factory :enrollment, class: CoalescingPanda::Enrollment do
    user
    course
    canvas_enrollment_id '123'
  end
end