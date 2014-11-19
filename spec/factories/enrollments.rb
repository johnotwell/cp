FactoryGirl.define do
  factory :enrollment do
    user
    course
    canvas_enrollment_id '123'
  end
end