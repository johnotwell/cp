require 'rails_helper'

RSpec.describe CoalescingPanda::CanvasBatch, :type => :model do
  it "default scope should order by created_at" do
    batch1 = FactoryGirl.create(:canvas_batch)
    batch2 = FactoryGirl.create(:canvas_batch)
    batch3 = FactoryGirl.create(:canvas_batch)
    expect(CoalescingPanda::CanvasBatch.all).to eq [batch3, batch2, batch1]
  end
end

