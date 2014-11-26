FactoryGirl.define do
  factory :course, class: CoalescingPanda::Course do
    account
    term
    name "Test Course"

    sequence :canvas_course_id do |n|
      n
    end
  end
end