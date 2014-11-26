FactoryGirl.define do
  factory :enrollment, class: CoalescingPanda::Enrollment do
    user
    section
    sequence :canvas_enrollment_id do |n|
      n
    end
    enrollment_type "StudentEnrollment"
  end
end