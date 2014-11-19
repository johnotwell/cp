FactoryGirl.define do
  factory :submission do
    user
    assignment
    canvas_submission_id '123'
    graded false
  end
end