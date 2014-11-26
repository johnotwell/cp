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

  context "validations" do
    it "should require an account" do
      expect(FactoryGirl.build(:user, coalescing_panda_lti_account_id: "")).to_not be_valid
    end

    it "should require a canvas id" do
      expect(FactoryGirl.build(:user, canvas_user_id: "")).to_not be_valid
    end

    it 'should be unique to an account' do
      account = FactoryGirl.create(:account)
      user = FactoryGirl.create(:user, account: account, canvas_user_id: "1")
      expect { FactoryGirl.create(:user, account: account, canvas_user_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:user)).to be_valid
    end
  end
end