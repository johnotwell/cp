FactoryGirl.define do
  factory :submission, class: CoalescingPanda::Submission do
    user
    assignment
    canvas_submission_id '123'
    graded false
  end
end