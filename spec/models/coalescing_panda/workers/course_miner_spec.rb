require 'rails_helper'

RSpec.describe CoalescingPanda::Workers::CourseMiner, :type => :model do
  let(:course) { FactoryGirl.create(:course) }
  let(:worker) { CoalescingPanda::Workers::CourseMiner.new(course, [:sections, :users, :enrollments, :assignments, :submissions]) }
  let(:users_response) {[
    {"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"},
    {"id"=>2, "name"=>"student1@test.com", "sortable_name"=>"student1@test.com", "short_name"=>"student1@test.com", "login_id"=>"student1@test.com"},
    {"id"=>3, "name"=>"student2@test.com", "sortable_name"=>"student2@test.com", "short_name"=>"student2@test.com", "login_id"=>"student2@test.com"}
  ]}
  let(:sections_response) {[
    {"course_id"=>1, "end_at"=>nil, "id"=>1, "name"=>"Course1", "nonxlist_course_id"=>nil, "start_at"=>nil, "sis_section_id"=>nil, "sis_course_id"=>"DOCSTUCOMM", "integration_id"=>nil, "sis_import_id"=>nil}
  ]}
  let(:enrollments_response) {[
    {"associated_user_id"=>nil, "course_id"=>1, "course_section_id"=>1, "created_at"=>"2014-11-07T21:17:54Z", "end_at"=>nil, "id"=>1, "limit_privileges_to_course_section"=>false, "root_account_id"=>1, "start_at"=>nil, "type"=>"TeacherEnrollment", "updated_at"=>"2014-11-11T22:11:19Z", "user_id"=>1, "enrollment_state"=>"active", "role"=>"TeacherEnrollment", "role_id"=>4, "last_activity_at"=>"2014-11-24T16:48:54Z", "total_activity_time"=>63682, "sis_import_id"=>nil, "sis_course_id"=>"DOCSTUCOMM", "course_integration_id"=>nil, "sis_section_id"=>nil, "section_integration_id"=>nil, "html_url"=>"http://localhost:3000/courses/1/users/1", "user"=>{"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"}},
    {"associated_user_id"=>nil, "course_id"=>1, "course_section_id"=>1, "created_at"=>"2014-11-07T21:18:16Z", "end_at"=>nil, "id"=>2, "limit_privileges_to_course_section"=>false, "root_account_id"=>1, "start_at"=>nil, "type"=>"StudentEnrollment", "updated_at"=>"2014-11-20T23:18:17Z", "user_id"=>2, "enrollment_state"=>"active", "role"=>"StudentEnrollment", "role_id"=>3, "last_activity_at"=>"2014-11-11T16:49:59Z", "total_activity_time"=>9243, "sis_import_id"=>nil, "grades"=>{"html_url"=>"http://localhost:3000/courses/1/grades/2", "current_score"=>90, "final_score"=>90, "current_grade"=>nil, "final_grade"=>nil}, "sis_course_id"=>"DOCSTUCOMM", "course_integration_id"=>nil, "sis_section_id"=>nil, "section_integration_id"=>nil, "html_url"=>"http://localhost:3000/courses/1/users/2", "user"=>{"id"=>2, "name"=>"student1@test.com", "sortable_name"=>"student1@test.com", "short_name"=>"student1@test.com", "login_id"=>"student1@test.com"}},
    {"associated_user_id"=>nil, "course_id"=>1, "course_section_id"=>1, "created_at"=>"2014-11-07T21:18:17Z", "end_at"=>nil, "id"=>3, "limit_privileges_to_course_section"=>false, "root_account_id"=>1, "start_at"=>nil, "type"=>"StudentEnrollment", "updated_at"=>"2014-11-20T23:18:21Z", "user_id"=>3, "enrollment_state"=>"active", "role"=>"StudentEnrollment", "role_id"=>3, "last_activity_at"=>"2014-11-10T22:10:15Z", "total_activity_time"=>921, "sis_import_id"=>nil, "grades"=>{"html_url"=>"http://localhost:3000/courses/1/grades/3", "current_score"=>80, "final_score"=>80, "current_grade"=>nil, "final_grade"=>nil}, "sis_course_id"=>"DOCSTUCOMM", "course_integration_id"=>nil, "sis_section_id"=>nil, "section_integration_id"=>nil, "html_url"=>"http://localhost:3000/courses/1/users/3", "user"=>{"id"=>3, "name"=>"student2@test.com", "sortable_name"=>"student2@test.com", "short_name"=>"student2@test.com", "login_id"=>"student2@test.com"}},
  ]}
  let(:assignments_response) {[
    {"assignment_group_id"=>1, "automatic_peer_reviews"=>false, "created_at"=>"2014-11-18T18:04:38Z", "description"=>"<p>What is your name?</p>", "due_at"=>nil, "grade_group_students_individually"=>false, "grading_standard_id"=>nil, "grading_type"=>"points", "group_category_id"=>nil, "id"=>1, "lock_at"=>nil, "peer_reviews"=>false, "points_possible"=>100, "position"=>1, "post_to_sis"=>true, "unlock_at"=>nil, "updated_at"=>"2014-11-18T18:04:42Z", "course_id"=>1, "name"=>"Gimme your name", "submission_types"=>["online_text_entry"], "has_submitted_submissions"=>false, "muted"=>false, "html_url"=>"http://localhost:3000/courses/1/assignments/1", "needs_grading_count"=>0, "integration_id"=>nil, "integration_data"=>{}, "published"=>true, "unpublishable"=>true, "locked_for_user"=>false},
    {"assignment_group_id"=>1, "automatic_peer_reviews"=>false, "created_at"=>"2014-11-18T19:10:28Z", "description"=>"<p>What is your Favorite Color?</p>", "due_at"=>nil, "grade_group_students_individually"=>false, "grading_standard_id"=>nil, "grading_type"=>"points", "group_category_id"=>nil, "id"=>2, "lock_at"=>nil, "peer_reviews"=>false, "points_possible"=>100, "position"=>2, "post_to_sis"=>true, "unlock_at"=>nil, "updated_at"=>"2014-11-18T19:10:30Z", "course_id"=>1, "name"=>"Favorite Color", "submission_types"=>["online_text_entry"], "has_submitted_submissions"=>false, "muted"=>false, "html_url"=>"http://localhost:3000/courses/1/assignments/2", "needs_grading_count"=>0, "integration_id"=>nil, "integration_data"=>{}, "published"=>true, "unpublishable"=>true, "locked_for_user"=>false}
  ]}
  let(:submissions_response1) {[
    {"assignment_id"=>1, "attempt"=>nil, "body"=>nil, "grade"=>"70", "grade_matches_current_submission"=>true, "graded_at"=>"2014-11-20T23:18:19Z", "grader_id"=>1, "id"=>3, "score"=>70, "submission_type"=>nil, "submitted_at"=>nil, "url"=>nil, "user_id"=>3, "workflow_state"=>"graded", "late"=>false, "preview_url"=>"http://localhost:3000/courses/1/assignments/1/submissions/3?preview=1"},
    {"assignment_id"=>1, "attempt"=>nil, "body"=>nil, "grade"=>"100", "grade_matches_current_submission"=>true, "graded_at"=>"2014-11-20T23:18:14Z", "grader_id"=>1, "id"=>1, "score"=>100, "submission_type"=>nil, "submitted_at"=>nil, "url"=>nil, "user_id"=>2, "workflow_state"=>"graded", "late"=>false, "preview_url"=>"http://localhost:3000/courses/1/assignments/1/submissions/2?preview=1"}
  ]}
  let(:submissions_response2) {[
    {"assignment_id"=>2, "attempt"=>nil, "body"=>nil, "grade"=>"90", "grade_matches_current_submission"=>true, "graded_at"=>"2014-11-20T23:18:21Z", "grader_id"=>1, "id"=>4, "score"=>90, "submission_type"=>nil, "submitted_at"=>nil, "url"=>nil, "user_id"=>3, "workflow_state"=>"graded", "late"=>false, "preview_url"=>"http://localhost:3000/courses/1/assignments/2/submissions/3?preview=1"},
    {"assignment_id"=>2, "attempt"=>nil, "body"=>nil, "grade"=>"80", "grade_matches_current_submission"=>true, "graded_at"=>"2014-11-20T23:18:17Z", "grader_id"=>1, "id"=>2, "score"=>80, "submission_type"=>nil, "submitted_at"=>nil, "url"=>nil, "user_id"=>2, "workflow_state"=>"graded", "late"=>false, "preview_url"=>"http://localhost:3000/courses/1/assignments/2/submissions/2?preview=1"}
  ]}

  before do
    Bearcat::Client.any_instance.stub(:list_course_users) { double(Bearcat::ApiArray, :all_pages! => users_response) }
    Bearcat::Client.any_instance.stub(:course_sections) { double(Bearcat::ApiArray, :all_pages! => sections_response) }
    Bearcat::Client.any_instance.stub(:course_enrollments) { double(Bearcat::ApiArray, :all_pages! => enrollments_response) }
    Bearcat::Client.any_instance.stub(:assignments) { double(Bearcat::ApiArray, :all_pages! => assignments_response) }
    Bearcat::Client.any_instance.stub(:get_course_submissions).with("1", "1") { double(Bearcat::ApiArray, :all_pages! => submissions_response1) }
    Bearcat::Client.any_instance.stub(:get_course_submissions).with("1", "2") { double(Bearcat::ApiArray, :all_pages! => submissions_response2) }
  end

  describe '#initialize' do
    it 'should set instance variables a user' do
      expect(worker.course).to eq course
      expect(worker.account).to eq course.account
      expect(worker.options).to eq [:sections, :users, :enrollments, :assignments, :submissions]
      expect(worker.batch).to eq CoalescingPanda::CanvasBatch.last
    end
  end

  describe '#api_client' do
    it 'returns a bearcat API client' do
      expect(worker.api_client.class).to eq Bearcat::Client
    end
  end

  describe '#start' do
    it 'updates the batch to started' do
      worker.start
      expect(worker.batch.status).to eq 'Completed'
    end
  end

  describe '#api_method' do
    it 'returns the correct api method' do
      expect(worker.api_method(:users)).to eq :list_course_users
      expect(worker.api_method(:sections)).to eq :course_sections
      expect(worker.api_method(:enrollments)).to eq :course_enrollments
      expect(worker.api_method(:assignments)).to eq :assignments
      expect(worker.api_method(:submissions)).to eq :get_course_submissions
    end

    it 'raises and error if method doesnt exist' do
      expect{ worker.api_method(:not_a_real_method) }.to raise_error
    end
  end

  describe '#create_records' do
    it 'creates sections' do
      CoalescingPanda::Section.destroy_all
      worker.create_records(sections_response, :sections)
      expect(CoalescingPanda::Section.count).to eq 1
    end

    it 'creates users' do
      CoalescingPanda::User.destroy_all
      worker.create_records(users_response, :users)
      expect(CoalescingPanda::User.count).to eq 3
    end

    it 'creates enrollments' do
      CoalescingPanda::Enrollment.destroy_all
      worker.create_records(enrollments_response, :enrollments)
      expect(CoalescingPanda::Enrollment.count).to eq 3
      expect(CoalescingPanda::Enrollment.last.workflow_state).to eq "active"
    end

    it 'creates assignments' do
      CoalescingPanda::Assignment.destroy_all
      worker.create_records(assignments_response, :assignments)
      expect(CoalescingPanda::Assignment.count).to eq 2
    end

    it 'creates submissions' do
      CoalescingPanda::Submission.destroy_all
      submissions_response = submissions_response1 + submissions_response2
      worker.create_records(submissions_response, :submissions)
      expect(CoalescingPanda::Submission.count).to eq 4
    end
  end

  describe '#standard_attributes' do
    let(:start_time) { Time.now.iso8601 }
    let(:end_time) { 3.weeks.from_now.iso8601 }

    it 'returns a sections attributes' do
      attributes = {"course_id"=>1, "end_at"=>end_time, "id"=>1, "name"=>"Course1", "nonxlist_course_id"=>nil, "start_at"=>start_time, "sis_section_id"=>"1234", "sis_course_id"=>"DOCSTUCOMM", "integration_id"=>nil, "sis_import_id"=>nil}
      record = CoalescingPanda::Section.new
      expect(worker.standard_attributes(record, attributes)).to eq({"end_at"=>end_time, "name"=>"Course1", "start_at"=>start_time})
    end

    it 'returns a users attributes' do
      attributes = {"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"}
      record = CoalescingPanda::User.new
      expect(worker.standard_attributes(record, attributes)).to eq({"name" => "teacher@test.com"})
    end

    it 'returns enrollments attributes' do
      attributes = {"associated_user_id"=>nil, "course_id"=>1, "course_section_id"=>1, "created_at"=>"2014-11-07T21:17:54Z", "end_at"=>end_time, "id"=>1, "limit_privileges_to_course_section"=>false, "root_account_id"=>1, "start_at"=>start_time, "type"=>"TeacherEnrollment", "updated_at"=>"2014-11-11T22:11:19Z", "user_id"=>1, "enrollment_state"=>"active", "role"=>"TeacherEnrollment", "role_id"=>4, "last_activity_at"=>"2014-11-24T16:48:54Z", "total_activity_time"=>63682, "sis_import_id"=>nil, "sis_course_id"=>"DOCSTUCOMM", "course_integration_id"=>nil, "sis_section_id"=>nil, "section_integration_id"=>nil, "html_url"=>"http://localhost:3000/courses/1/users/1", "user"=>{"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"}}
      record = CoalescingPanda::Enrollment.new
      expect(worker.standard_attributes(record, attributes)).to eq({"created_at"=>"2014-11-07T21:17:54Z", "end_at"=>end_time, "start_at"=>start_time, "updated_at"=>"2014-11-11T22:11:19Z"})
    end

    it 'returns assignment attributes' do
      attributes = {"assignment_group_id"=>1, "automatic_peer_reviews"=>false, "created_at"=>"2014-11-18T18:04:38Z", "description"=>"<p>What is your name?</p>", "due_at"=>end_time, "grade_group_students_individually"=>false, "grading_standard_id"=>nil, "grading_type"=>"points", "group_category_id"=>nil, "id"=>1, "lock_at"=>start_time, "peer_reviews"=>false, "points_possible"=>100, "position"=>1, "post_to_sis"=>true, "unlock_at"=>nil, "updated_at"=>"2014-11-18T18:04:42Z", "course_id"=>1, "name"=>"Gimme your name", "submission_types"=>["online_text_entry"], "has_submitted_submissions"=>false, "muted"=>false, "html_url"=>"http://localhost:3000/courses/1/assignments/1", "needs_grading_count"=>0, "integration_id"=>nil, "integration_data"=>{}, "published"=>true, "unpublishable"=>true, "locked_for_user"=>false}
      record = CoalescingPanda::Assignment.new
      expect(worker.standard_attributes(record, attributes)).to eq({"created_at"=>"2014-11-18T18:04:38Z", "description"=>"<p>What is your name?</p>", "due_at"=>end_time, "lock_at"=>start_time, "points_possible"=>100, "unlock_at"=>nil, "updated_at"=>"2014-11-18T18:04:42Z", "name"=>"Gimme your name"})
    end

    it 'returns submission attributes' do
      attributes = {"assignment_id"=>1, "attempt"=>nil, "body"=>nil, "grade"=>"70", "grade_matches_current_submission"=>true, "graded_at"=>"2014-11-20T23:18:19Z", "grader_id"=>1, "id"=>3, "score"=>70, "submission_type"=>nil, "submitted_at"=>nil, "url"=>"http://test.com", "user_id"=>3, "workflow_state"=>"graded", "late"=>false, "preview_url"=>"http://localhost:3000/courses/1/assignments/1/submissions/3?preview=1"}
      record = CoalescingPanda::Submission.new
      expect(worker.standard_attributes(record, attributes)).to eq({"grade"=>"70", "score"=>70, "submitted_at"=>nil, "url"=>"http://test.com", "workflow_state"=>"graded"})
    end
  end

  describe '#sis_id' do
    it 'returns sis_source_id if one exists' do
      values = {"sis_source_id" => "1234"}
      expect(worker.sis_id(:users, values)).to eq "1234"
    end

    it 'returns sis_section_id if one exists' do
      values = {"sis_section_id" => "2345"}
      expect(worker.sis_id(:sections, values)).to eq "2345"
    end

    it 'returns nil if no valid sis_id' do
      values = {"not_valid_key" => "2345"}
      expect(worker.sis_id(:sections, values)).to eq nil
    end
  end

  describe '#create_associations' do
    let(:user) { FactoryGirl.create(:user, account: course.account) }

    it 'sets a user records account' do
      record = CoalescingPanda::User.new
      worker.create_associations(record, :users, {})
      expect(record.account).to eq course.account
    end

    it 'sets an enrollments user and section' do
      section = FactoryGirl.create(:section)
      course.sections << section
      record = CoalescingPanda::Enrollment.new
      worker.create_associations(record, :enrollments, {'user_id' => user.canvas_user_id, 'course_section_id' => section.canvas_section_id})
      expect(record.user).to eq user
      expect(record.section).to eq section
    end

    it 'sets an assignments course' do
      record = CoalescingPanda::Assignment.new
      worker.create_associations(record, :assignments, {})
      expect(record.course).to eq course
    end

    it 'sets an submissions' do
      assignment = FactoryGirl.create(:assignment, course: course)
      record = CoalescingPanda::Submission.new
      worker.create_associations(record, :submissions, {'user_id' => user.canvas_user_id, 'assignment_id' => assignment.canvas_assignment_id})
      expect(record.user).to eq user
      expect(record.assignment).to eq assignment
    end
  end
end