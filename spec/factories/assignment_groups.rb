FactoryGirl.define do
  factory :assignment_group, class: CoalescingPanda::AssignmentGroup do
    name "test assignment group"
    course
    context_id '1'
    context_type 'Course'
    position '1'
    group_weight 50.5
    workflow_state 'active'
    sequence :canvas_assignment_group_id do |n|
      "#{n}"
    end
  end
end