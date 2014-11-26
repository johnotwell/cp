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

  context "validations" do
    it "should require a coalescing_panda_course_id" do
      expect(FactoryGirl.build(:section, coalescing_panda_course_id: "")).to_not be_valid
    end

    it "should require a canvas id" do
      expect(FactoryGirl.build(:section, canvas_section_id: "")).to_not be_valid
    end

    it 'should be unique to a course' do
      course = FactoryGirl.create(:course)
      section = FactoryGirl.create(:section, course: course, canvas_section_id: "1")
      expect { FactoryGirl.create(:section, course: course, canvas_section_id: "1") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:section)).to be_valid
    end
  end
end