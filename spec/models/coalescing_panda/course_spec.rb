require 'rails_helper'

RSpec.describe CoalescingPanda::Course, :type => :model do
  let(:course) { FactoryGirl.create(:course) }

  context "associations" do
    it 'should belong_to an account' do
      expect(CoalescingPanda::Course.reflect_on_association(:account)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:account).macro).to eql(:belongs_to)
    end

    it 'should belong_to a term' do
      expect(CoalescingPanda::Course.reflect_on_association(:term)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:term).macro).to eql(:belongs_to)
    end

    it 'should have many sections' do
      expect(CoalescingPanda::Course.reflect_on_association(:sections)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:sections).macro).to eql(:has_many)
    end

    it 'should have many assignments' do
      expect(CoalescingPanda::Course.reflect_on_association(:assignments)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:assignments).macro).to eql(:has_many)
    end

    it 'should have many enrollments' do
      expect(CoalescingPanda::Course.reflect_on_association(:enrollments)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:enrollments).macro).to eql(:has_many)
    end

    it 'should have many users' do
      expect(CoalescingPanda::Course.reflect_on_association(:users)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:users).macro).to eql(:has_many)
    end
  end
end
