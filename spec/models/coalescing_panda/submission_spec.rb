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

  context "validations" do
    it "should require a user" do
      expect(FactoryGirl.build(:submission, coalescing_panda_user_id: "")).to_not be_valid
    end

    it "should require a assignment" do
      expect(FactoryGirl.build(:submission, coalescing_panda_assignment_id: "")).to_not be_valid
    end

    it "should require a canvas id" do
      expect(FactoryGirl.build(:submission, canvas_submission_id: "")).to_not be_valid
    end

    it 'should be unique to a user, assignment, and submission_id' do
      user = FactoryGirl.create(:user)
      assignment = FactoryGirl.create(:assignment)
      submission = FactoryGirl.create(:submission, user: user, assignment: assignment, canvas_submission_id: "1")
      expect { FactoryGirl.create(:submission, user: user, assignment: assignment, canvas_submission_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it 'should not be unique with a different submission id' do
      user = FactoryGirl.create(:user)
      assignment = FactoryGirl.create(:assignment)
      submission = FactoryGirl.create(:submission, user: user, assignment: assignment, canvas_submission_id: "1")
      expect { FactoryGirl.create(:submission, user: user, assignment: assignment, canvas_submission_id: "2") }.not_to raise_error
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:submission)).to be_valid
    end
  end
end