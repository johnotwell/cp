FactoryGirl.define do
  factory :section, class: CoalescingPanda::Section do
    course
    sequence :canvas_section_id do |n|
      n
    end

  end
end