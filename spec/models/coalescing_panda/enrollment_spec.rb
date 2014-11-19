require 'rails_helper'

RSpec.describe CoalescingPanda::Enrollment, :type => :model do
  let(:enrollment) { FactoryGirl.create(:enrollment) }

  context "associations" do
    it 'should belong_to a user' do
      expect(CoalescingPanda::Enrollment.reflect_on_association(:user)).to_not be_nil
      expect(CoalescingPanda::Enrollment.reflect_on_association(:user).macro).to eql(:belongs_to)
    end

    it 'should belong_to a section' do
      expect(CoalescingPanda::Enrollment.reflect_on_association(:section)).to_not be_nil
      expect(CoalescingPanda::Enrollment.reflect_on_association(:section).macro).to eql(:belongs_to)
    end
  end
end
