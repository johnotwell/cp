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

  context "validations" do
    it "should require a canvas id" do
      expect(FactoryGirl.build(:assignment, canvas_assignment_id: "")).to_not be_valid
    end

    it "should require a course" do
      expect(FactoryGirl.build(:assignment, coalescing_panda_course_id: "")).to_not be_valid
    end

    it 'should be unique to a course' do
      course = FactoryGirl.create(:course)
      assignment = FactoryGirl.create(:assignment, course: course, canvas_assignment_id: "1")
      expect { FactoryGirl.create(:assignment, course: course, canvas_assignment_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:assignment)).to be_valid
    end
  end

end