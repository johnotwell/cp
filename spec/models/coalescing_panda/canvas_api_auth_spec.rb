require 'spec_helper'

describe CoalescingPanda::CanvasApiAuth do

  it { should validate_uniqueness_of(:user_id).scoped_to(:api_domain)}
  it { should validate_presence_of(:user_id)}
  it {should validate_presence_of(:api_domain)}

  describe '#expired?' do
    let(:auth) { FactoryGirl.create :canvas_api_auth }

    it 'is not expired if expires_at is null or in the future' do
      auth.expires_at = nil
      expect(auth.expired?).to be_falsey
      auth.expires_at = 1.hour.ago
      expect(auth.expired?).to be_truthy
      auth.expires_at = 1.hour.from_now
      expect(auth.expired?).to be_falsey
    end
  end
end
