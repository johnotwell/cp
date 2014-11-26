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

  context "validations" do
    it "should require a canvas id" do
      expect(FactoryGirl.build(:enrollment, canvas_enrollment_id: "")).to_not be_valid
    end

    it "should require a coalescing_panda_user_id" do
      expect(FactoryGirl.build(:enrollment, coalescing_panda_user_id: "")).to_not be_valid
    end

    it "should require a coalescing_panda_section_id" do
      expect(FactoryGirl.build(:enrollment, coalescing_panda_section_id: "")).to_not be_valid
    end

    it 'should be unique to a user and section' do
      user = FactoryGirl.create(:user)
      section = FactoryGirl.create(:section)
      enrollment = FactoryGirl.create(:enrollment, user: user, section: section, canvas_enrollment_id: "1", enrollment_type: "StudentEnrollment")
      expect { FactoryGirl.create(:enrollment, user: user, section: section, canvas_enrollment_id: "1", enrollment_type: "StudentEnrollment") }.to raise_error ActiveRecord::RecordNotUnique
    end

    it 'should not be unique with a different enrollment type' do
      user = FactoryGirl.create(:user)
      section = FactoryGirl.create(:section)
      enrollment = FactoryGirl.create(:enrollment, user: user, section: section, canvas_enrollment_id: "1", enrollment_type: "StudentEnrollment")
      expect { FactoryGirl.create(:enrollment, user: user, section: section, canvas_enrollment_id: "2", enrollment_type: "TeacherEnrollment") }.not_to raise_error
    end

    it "should be valid with valid data" do
      expect(FactoryGirl.build(:enrollment)).to be_valid
    end
  end
end
