FactoryGirl.define do
  factory :term, class: CoalescingPanda::Term do
    account

    sequence :canvas_term_id do |n|
      n
    end
  end
end