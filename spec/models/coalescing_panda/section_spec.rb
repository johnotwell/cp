require 'rails_helper'

RSpec.describe CoalescingPanda::Section, :type => :model do
  let(:section) { FactoryGirl.create(:section) }

  context "associations" do
    it 'should belong_to a course' do
      expect(CoalescingPanda::Section.reflect_on_association(:course)).to_not be_nil
      expect(CoalescingPanda::Section.reflect_on_association(:course).macro).to eql(:belongs_to)
    end

    it 'should have many enrollments' do
      expect(CoalescingPanda::Section.reflect_on_association(:enrollments)).to_not be_nil
      expect(CoalescingPanda::Section.reflect_on_association(:enrollments).macro).to eql(:has_many)
    end

    it 'should have many users' do
      expect(CoalescingPanda::Section.reflect_on_association(:users)).to_not be_nil
      expect(CoalescingPanda::Section.reflect_on_association(:users).macro).to eql(:has_many)
    end
  end
end