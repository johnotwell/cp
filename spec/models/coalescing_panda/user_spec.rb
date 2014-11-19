require 'rails_helper'

RSpec.describe CoalescingPanda::User, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context "associations" do
    it 'should have many enrollments' do
      expect(CoalescingPanda::User.reflect_on_association(:enrollments)).to_not be_nil
      expect(CoalescingPanda::User.reflect_on_association(:enrollments).macro).to eql(:has_many)
    end

    it 'should have many sections' do
      expect(CoalescingPanda::User.reflect_on_association(:sections)).to_not be_nil
      expect(CoalescingPanda::User.reflect_on_association(:sections).macro).to eql(:has_many)
    end

    it 'should have many courses' do
      expect(CoalescingPanda::User.reflect_on_association(:courses)).to_not be_nil
      expect(CoalescingPanda::User.reflect_on_association(:courses).macro).to eql(:has_many)
    end

    it 'should have many submissions' do
      expect(CoalescingPanda::User.reflect_on_association(:submissions)).to_not be_nil
      expect(CoalescingPanda::User.reflect_on_association(:submissions).macro).to eql(:has_many)
    end
  end
end