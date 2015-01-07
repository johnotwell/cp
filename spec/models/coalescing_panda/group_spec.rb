require 'rails_helper'

RSpec.describe CoalescingPanda::Group, :type => :model do
  let(:term) { FactoryGirl.create(:group) }

  context "associations" do
    it 'should belong_to a context' do
      expect(CoalescingPanda::Group.reflect_on_association(:context)).to_not be_nil
      expect(CoalescingPanda::Group.reflect_on_association(:context).macro).to eql(:belongs_to)
    end

    it 'should have_many group_memberships' do
      expect(CoalescingPanda::Group.reflect_on_association(:group_memberships)).to_not be_nil
      expect(CoalescingPanda::Group.reflect_on_association(:group_memberships).macro).to eql(:has_many)
    end
  end
end