require 'rails_helper'

RSpec.describe CoalescingPanda::LtiAccount, :type => :model do
  let(:account) { FactoryGirl.create(:account) }

  context "associations" do
    it 'should have many terms' do
      expect(CoalescingPanda::LtiAccount.reflect_on_association(:terms)).to_not be_nil
      expect(CoalescingPanda::LtiAccount.reflect_on_association(:terms).macro).to eql(:has_many)
    end

    it 'should have many courses' do
      expect(CoalescingPanda::LtiAccount.reflect_on_association(:courses)).to_not be_nil
      expect(CoalescingPanda::LtiAccount.reflect_on_association(:courses).macro).to eql(:has_many)
    end
  end

  context 'validations' do
    it 'should require a canvas id' do
      expect(FactoryGirl.build(:account, canvas_account_id: "")).to_not be_valid
    end
  end
end
