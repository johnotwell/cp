require 'rails_helper'

RSpec.describe CoalescingPanda::GroupMembership, :type => :model do
  let(:term) { FactoryGirl.create(:group) }

  context "associations" do
    it 'should belong_to a group' do
      expect(CoalescingPanda::GroupMembership.reflect_on_association(:group)).to_not be_nil
      expect(CoalescingPanda::GroupMembership.reflect_on_association(:group).macro).to eql(:belongs_to)
    end

    it 'should belong_to a user' do
      expect(CoalescingPanda::GroupMembership.reflect_on_association(:user)).to_not be_nil
      expect(CoalescingPanda::GroupMembership.reflect_on_association(:user).macro).to eql(:belongs_to)
    end
  end
end