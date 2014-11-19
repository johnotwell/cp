require 'rails_helper'

RSpec.describe CoalescingPanda::Submission, :type => :model do
  let(:submission) { FactoryGirl.create(:submission) }

  context "associations" do
    it 'should belong_to a user' do
      expect(CoalescingPanda::Submission.reflect_on_association(:user)).to_not be_nil
      expect(CoalescingPanda::Submission.reflect_on_association(:user).macro).to eql(:belongs_to)
    end

    it 'should belong_to a assignment' do
      expect(CoalescingPanda::Submission.reflect_on_association(:assignment)).to_not be_nil
      expect(CoalescingPanda::Submission.reflect_on_association(:assignment).macro).to eql(:belongs_to)
    end

  end
end