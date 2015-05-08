require 'rails_helper'

RSpec.describe CoalescingPanda::AssignmentGroup, :type => :model do
  let(:assignment_group) { FactoryGirl.create(:assignment_group) }

  context "associations" do
    it 'should belong_to a course' do
      expect(CoalescingPanda::AssignmentGroup.reflect_on_association(:course)).to_not be_nil
      expect(CoalescingPanda::AssignmentGroup.reflect_on_association(:course).macro).to eql(:belongs_to)
    end

    it 'should have many assignments' do
      expect(CoalescingPanda::AssignmentGroup.reflect_on_association(:assignments)).to_not be_nil
      expect(CoalescingPanda::AssignmentGroup.reflect_on_association(:assignments).macro).to eql(:has_many)
    end
  end

  context "validations" do
    it "should require a canvas id" do
      expect(FactoryGirl.build(:assignment_group, canvas_assignment_group_id: "")).to_not be_valid
    end

    it "should require a course" do
      expect(FactoryGirl.build(:assignment_group, coalescing_panda_course_id: "")).to_not be_valid
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:assignment_group)).to be_valid
    end
  end

end