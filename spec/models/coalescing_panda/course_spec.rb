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

    it 'should have many groups' do
      expect(CoalescingPanda::Course.reflect_on_association(:groups)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:groups).macro).to eql(:has_many)
    end

    it 'should have many group_memberships' do
      expect(CoalescingPanda::Course.reflect_on_association(:group_memberships)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:group_memberships).macro).to eql(:has_many)
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

    it 'should have many assignment groups' do
      expect(CoalescingPanda::Course.reflect_on_association(:assignment_groups)).to_not be_nil
      expect(CoalescingPanda::Course.reflect_on_association(:assignment_groups).macro).to eql(:has_many)
    end
  end

  context "validations" do
    it "should require a canvas id" do
      expect(FactoryGirl.build(:course, canvas_course_id: "")).to_not be_valid
    end

    it "should require an lti_account" do
      expect(FactoryGirl.build(:course, coalescing_panda_lti_account_id: "")).to_not be_valid
    end

    it 'should be unique to an account' do
      account = FactoryGirl.create(:account)
      course = FactoryGirl.create(:course, account: account, canvas_course_id: "1")
      expect { FactoryGirl.create(:course, account: account, canvas_course_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it 'should be unique to an term' do
      term = FactoryGirl.create(:term)
      course = FactoryGirl.create(:course, term: term, canvas_course_id: "1")
      expect { FactoryGirl.create(:course, term: term, canvas_course_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:course)).to be_valid
    end
  end
end
