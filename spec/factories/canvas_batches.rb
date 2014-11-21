FactoryGirl.define do
  factory :canvas_batch, class: CoalescingPanda::CanvasBatch do
    percent_complete 0.0
    status "Pending"
  end
end
