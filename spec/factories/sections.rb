FactoryGirl.define do
  factory :section, class: CoalescingPanda::Section do
    course
    canvas_section_id '123'
  end
end