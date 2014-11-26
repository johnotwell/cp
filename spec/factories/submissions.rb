FactoryGirl.define do
  factory :submission, class: CoalescingPanda::Submission do
    user
    assignment
    sequence :canvas_submission_id do |n|
      n
    end
  end
end