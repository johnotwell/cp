require 'rails_helper'

RSpec.describe CoalescingPanda::Assignment, :type => :model do
  let(:assignment) { FactoryGirl.create(:assignment) }

  context "associations" do
    it 'should belong_to a course' do
      expect(CoalescingPanda::Assignment.reflect_on_association(:course)).to_not be_nil
      expect(CoalescingPanda::Assignment.reflect_on_association(:course).macro).to eql(:belongs_to)
    end

    it 'should have many submisssions' do
      expect(CoalescingPanda::Assignment.reflect_on_association(:submissions)).to_not be_nil
      expect(CoalescingPanda::Assignment.reflect_on_association(:submissions).macro).to eql(:has_many)
    end
  end

end