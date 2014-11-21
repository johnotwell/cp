FactoryGirl.define do
  factory :course, class: CoalescingPanda::Course do
    account
    name "Test Course"
    canvas_course_id "1"
  end
end