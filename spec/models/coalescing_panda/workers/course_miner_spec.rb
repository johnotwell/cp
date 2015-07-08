require 'rails_helper'

RSpec.describe CoalescingPanda::Workers::CourseMiner, :type => :model do
  let(:course) { FactoryGirl.create(:course) }
  let(:worker) { CoalescingPanda::Workers::CourseMiner.new(course, [:sections, :users, :enrollments, :assignments, :assignment_groups, :submissions, :groups, :group_memberships]) }
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
    {"assignment_group_id"=>1, "automatic_peer_reviews"=>false, "created_at"=>"2014-11-18T18:04:38Z", "description"=>"<p>What is your name?</p>", "due_at"=>nil, "grade_group_students_individually"=>false, "grading_standard_id"=>nil, "grading_type"=>"points", "group_category_id"=>1, "id"=>1, "lock_at"=>nil, "peer_reviews"=>false, "points_possible"=>100, "position"=>1, "post_to_sis"=>true, "unlock_at"=>nil, "updated_at"=>"2014-11-18T18:04:42Z", "course_id"=>1, "name"=>"Gimme your name", "submission_types"=>["online_text_entry"], "has_submitted_submissions"=>false, "muted"=>false, "html_url"=>"http://localhost:3000/courses/1/assignments/1", "needs_grading_count"=>0, "integration_id"=>nil, "integration_data"=>{}, "published"=>true, "unpublishable"=>true, "locked_for_user"=>false},
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
  let(:group_categories_response){[
    {"auto_leader" => "first", "group_limit" => nil, "id" => 1, "name" => "mark red", "role" => nil, "self_signup" => nil, "context_type" => "Course", "course_id" => 1, "protected" => false, "allows_multiple_memberships" => false, "is_member" => false}
  ]}
  let(:groups_response){[
    {"description"=> nil, "group_category_id"=> 1, "id"=> 4, "is_public"=> false, "join_level"=> "invitation_only", "max_membership"=> 5, "name"=> "Student Group 1", "members_count"=> 2, "storage_quota_mb"=> 50, "context_type"=> "CoalescingPanda::Course", "course_id"=> 1, "avatar_url"=> nil, "role"=> nil, "leader"=> {"id"=>2}},
    {"description"=> nil, "group_category_id"=> nil, "id"=> 5, "is_public"=> false, "join_level"=> "invitation_only", "max_membership"=> 5, "name"=> "Student Group 2", "members_count"=> 2, "storage_quota_mb"=> 50, "context_type"=> "CoalescingPanda::Course", "course_id"=> 1, "avatar_url"=> nil, "role"=> nil, "leader"=> nil}
  ]}
  let(:membership_response){[
    {"group_id"=> 4, "id"=> 13, "moderator"=> "true", "user_id"=> 2, "workflow_state"=> "accepted"},
    {"group_id"=> 4, "id"=> 14, "moderator"=> "false", "user_id"=> 3, "workflow_state"=> "accepted"}
  ]}
  let(:assignment_groups_response) {[
    {"group_weight" => 500, "id" => 3, "name" => "Assignments", "position" => 3, "rules" => {} }
  ]}

  before do
    Bearcat::Client.any_instance.stub(:list_course_users) { double(Bearcat::ApiArray, :all_pages! => users_response) }
    Bearcat::Client.any_instance.stub(:course_sections) { double(Bearcat::ApiArray, :all_pages! => sections_response) }
    Bearcat::Client.any_instance.stub(:course_enrollments) { double(Bearcat::ApiArray, :all_pages! => enrollments_response) }
    Bearcat::Client.any_instance.stub(:assignments) { double(Bearcat::ApiArray, :all_pages! => assignments_response) }
    Bearcat::Client.any_instance.stub(:get_course_submissions) { double(Bearcat::ApiArray, :all_pages! => {}) }
    Bearcat::Client.any_instance.stub(:get_course_submissions).with("1", "1") { double(Bearcat::ApiArray, :all_pages! => submissions_response1) }
    Bearcat::Client.any_instance.stub(:get_course_submissions).with("1", "2") { double(Bearcat::ApiArray, :all_pages! => submissions_response2) }
    Bearcat::Client.any_instance.stub(:course_groups) { double(Bearcat::ApiArray, :all_pages! => groups_response) }
    Bearcat::Client.any_instance.stub(:list_group_memberships) { double(Bearcat::ApiArray, :all_pages! => membership_response) }
    Bearcat::Client.any_instance.stub(:list_assignment_groups) { double(Bearcat::ApiArray, :all_pages! => assignment_groups_response) }
  end

  describe '#initialize' do
    it 'should set instance variables a user' do
      expect(worker.course).to eq course
      expect(worker.account).to eq course.account
      expect(worker.options).to eq [:sections, :users, :enrollments, :assignments, :assignment_groups, :submissions, :groups, :group_memberships]
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

  describe '#create_records' do
    it 'creates sections' do
      CoalescingPanda::Section.destroy_all
      worker.sync_sections(sections_response)
      expect(CoalescingPanda::Section.count).to eq 1
    end

    it 'creates users' do
      CoalescingPanda::User.destroy_all
      worker.sync_users(users_response)
      expect(CoalescingPanda::User.count).to eq 3
    end

    it 'creates enrollments' do
      CoalescingPanda::Enrollment.destroy_all
      worker.sync_sections(sections_response)
      worker.sync_users(users_response)
      worker.sync_enrollments(enrollments_response)
      expect(CoalescingPanda::Enrollment.count).to eq 3
      expect(CoalescingPanda::Enrollment.last.workflow_state).to eq "active"
    end

    it 'creates group categories' do
      worker.sync_group_categories(group_categories_response)
      expect(CoalescingPanda::GroupCategory.count).to eq 1
    end

    it 'creates assignments' do
      CoalescingPanda::Assignment.destroy_all
      worker.sync_group_categories(group_categories_response)
      worker.sync_assignments(assignments_response)
      expect(CoalescingPanda::Assignment.count).to eq 2
      expect(CoalescingPanda::Assignment.find_by(canvas_assignment_id: 1).group_category).to_not be_nil
    end

    it 'creates assignment groups' do
      CoalescingPanda::AssignmentGroup.destroy_all
      expect(CoalescingPanda::AssignmentGroup.count).to eq 0
      worker.sync_assignment_groups(assignment_groups_response)
       expect(CoalescingPanda::AssignmentGroup.count).to eq 1
    end

    it 'creates submissions' do
      CoalescingPanda::Submission.destroy_all
      submissions_response = submissions_response1 + submissions_response2
      worker.sync_sections(sections_response)
      worker.sync_users(users_response)
      worker.sync_enrollments(enrollments_response)
      worker.sync_assignments(assignments_response)
      worker.sync_submissions(submissions_response)
      expect(CoalescingPanda::Submission.count).to eq 4
    end

    it 'creates groups' do
      CoalescingPanda::Group.destroy_all
      worker.sync_group_categories(group_categories_response)
      worker.sync_groups(groups_response)
      expect(CoalescingPanda::Group.count).to eq 2
      expect(CoalescingPanda::Group.find_by(canvas_group_id: 4)).to_not be_nil
    end

    it 'creates groups with leaders' do
      CoalescingPanda::Group.destroy_all
      worker.sync_sections(sections_response)
      worker.sync_users(users_response)
      worker.sync_enrollments(enrollments_response)
      worker.sync_groups(groups_response)
      expect(CoalescingPanda::Group.count).to eq 2
      expect(CoalescingPanda::Group.where(canvas_group_id: "4").first.leader).to_not be_nil
    end

    it 'creates group memberships' do
      CoalescingPanda::GroupMembership.destroy_all
      worker.sync_group_memberships(membership_response)
      expect(CoalescingPanda::GroupMembership.count).to eq 2
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
      attributes = {"associated_user_id"=>nil, "course_id"=>1, "course_section_id"=>1, "created_at"=>"2014-11-07T21:17:54Z", "end_at"=>end_time, "id"=>1, "limit_privileges_to_course_section"=>false, "root_account_id"=>1, "start_at"=>start_time, "enrollment_type"=>"TeacherEnrollment", "updated_at"=>"2014-11-11T22:11:19Z", "user_id"=>1, "enrollment_state"=>"active", "role"=>"TeacherEnrollment", "role_id"=>4, "last_activity_at"=>"2014-11-24T16:48:54Z", "total_activity_time"=>63682, "sis_import_id"=>nil, "sis_course_id"=>"DOCSTUCOMM", "course_integration_id"=>nil, "sis_section_id"=>nil, "section_integration_id"=>nil, "html_url"=>"http://localhost:3000/courses/1/users/1", "user"=>{"id"=>1, "name"=>"teacher@test.com", "sortable_name"=>"teacher@test.com", "short_name"=>"teacher@test.com", "login_id"=>"teacher@test.com"}}
      record = CoalescingPanda::Enrollment.new
      expect(worker.standard_attributes(record, attributes)).to eq({"created_at"=>"2014-11-07T21:17:54Z", "end_at"=>end_time, "start_at"=>start_time, "enrollment_type"=>"TeacherEnrollment", "updated_at"=>"2014-11-11T22:11:19Z"})
    end

    it 'returns assignment attributes' do
      attributes = {"assignment_group_id"=>1, "automatic_peer_reviews"=>false, "created_at"=>"2014-11-18T18:04:38Z", "description"=>"<p>What is your name?</p>", "due_at"=>end_time, "grade_group_students_individually"=>false, "grading_standard_id"=>nil, "grading_type"=>"points", "group_category_id"=>nil, "id"=>1, "lock_at"=>start_time, "peer_reviews"=>false, "points_possible"=>100, "position"=>1, "post_to_sis"=>true, "unlock_at"=>nil, "updated_at"=>"2014-11-18T18:04:42Z", "course_id"=>1, "name"=>"Gimme your name", "submission_types"=>["online_text_entry"], "has_submitted_submissions"=>false, "muted"=>false, "html_url"=>"http://localhost:3000/courses/1/assignments/1", "needs_grading_count"=>0, "integration_id"=>nil, "integration_data"=>{}, "published"=>true, "unpublishable"=>true, "locked_for_user"=>false}
      record = CoalescingPanda::Assignment.new
      expect(worker.standard_attributes(record, attributes)).to eq({"created_at"=>"2014-11-18T18:04:38Z", "description"=>"<p>What is your name?</p>", "due_at"=>end_time, "grade_group_students_individually" => false, "group_category_id" => nil, "lock_at"=>start_time, "points_possible"=>100, "published" => true, "submission_types" => ["online_text_entry"], "unlock_at"=>nil, "updated_at"=>"2014-11-18T18:04:42Z", "name"=>"Gimme your name"})
    end

    it 'returns submission attributes' do
      attributes = {"assignment_id"=>1, "attempt"=>nil, "body"=>nil, "grade"=>"70", "grade_matches_current_submission"=>true, "graded_at"=>"2014-11-20T23:18:19Z", "grader_id"=>1, "id"=>3, "score"=>70, "submission_type"=>nil, "submitted_at"=>nil, "url"=>"http://test.com", "user_id"=>3, "workflow_state"=>"graded", "late"=>false, "preview_url"=>"http://localhost:3000/courses/1/assignments/1/submissions/3?preview=1"}
      record = CoalescingPanda::Submission.new
      expect(worker.standard_attributes(record, attributes)).to eq({"grade"=>"70", "score"=>70, "submitted_at"=>nil, "url"=>"http://test.com", "workflow_state"=>"graded"})
    end

    it 'returns group attributes' do
      attributes = {"description"=> nil,"group_category_id"=> 3,"id"=> 4,"is_public"=> false,"join_level"=> "invitation_only","max_membership"=> 5,"name"=> "Student Group 1","members_count"=> 2,"storage_quota_mb"=> 50,"context_type"=> "Course","course_id"=> 3709,"avatar_url"=> nil,"role"=> nil,"leader"=> nil}
      record = CoalescingPanda::Group.new
      expect(worker.standard_attributes(record, attributes)).to eq({"description" => nil , "group_category_id" => 3, "name" => "Student Group 1", "members_count" => 2, "context_type" => 'Course'})
    end

    it 'returns group membership attributes' do
      attributes = {"group_id"=> 4,"id"=> 13,"moderator"=> "false","user_id"=> 2,"workflow_state"=> "accepted"}
      record = CoalescingPanda::GroupMembership.new
      expect(worker.standard_attributes(record, attributes)).to eq({"moderator"=> "false", "workflow_state" => "accepted"})
    end
  end

  describe "#setup_batch" do
    it 'should return a new batch if none are in progress' do
      batch = worker.setup_batch
      expect(batch.status).to eq 'Queued'
    end

    it 'should return a started batch if one exists' do
      batch = worker.setup_batch
      batch.update_attributes(status: 'Started')
      batch = worker.setup_batch
      expect(batch.status).to eq 'Started'
    end
  end
end
