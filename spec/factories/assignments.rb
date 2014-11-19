FactoryGirl.define do
  factory :assignment do
    name "test assignment"
    course
    sequence :canvas_assignment_id do |n|
      "#{n}"
    end
  end
end