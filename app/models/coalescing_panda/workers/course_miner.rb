class CoalescingPanda::Workers::CourseMiner
  SUPPORTED_MODELS = [:sections, :users, :enrollments, :assignments, :submissions, :groups, :group_memberships] #ORDER MATTERS!!

  attr_accessor :options, :account, :course, :batch, :course_section_ids, :enrollment_ids, :assignment_ids, :group_ids

  def initialize(course, options = [])
    @course = course
    @account = course.account
    @options = options
    @batch = CoalescingPanda::CanvasBatch.create(context: course, status: "Queued")
    @course_section_ids = []
    @enrollment_ids = []
    @assignment_ids = []
    @group_ids = []
  end

  def api_client
    @api_client ||= Bearcat::Client.new(prefix: account.settings[:base_url], token: account.settings[:account_admin_api_token])
  end

  def start
    begin
      batch.update_attributes(status: "Started", percent_complete: 0)
      SUPPORTED_MODELS.each_with_index do |model_key, index|
        index += 1
        process_api_data(model_key.to_sym) if options.include?(model_key)
        percent_complete = (index/(options.count.nonzero? || 1).to_f * 100).round(1)
        batch.update_attributes(percent_complete: percent_complete)
      end
      delete_removed_records
      batch.update_attributes(status: "Completed", percent_complete: 100)
    rescue => e
      batch.update_attributes(status: "Error", message: e.message)
    end
  end
  handle_asynchronously :start

  def process_api_data(key)
    case key
    when :sections
      collection = api_client.course_sections(course.canvas_course_id).all_pages!
      sync_sections(collection)
    when :users
      collection = api_client.list_course_users(course.canvas_course_id).all_pages!
      sync_users(collection)
    when :enrollments
      collection = api_client.course_enrollments(course.canvas_course_id).all_pages!
      sync_enrollments(collection)
    when :assignments
      collection = api_client.assignments(course.canvas_course_id).all_pages!
      sync_assignments(collection)
    when :submissions
      collection = []
      course.assignments.each do |assignment|
        api_client.get_course_submissions(course.canvas_course_id, assignment.canvas_assignment_id).all_pages!.each do |submissions|
          collection << submissions
        end
      end
      sync_submissions(collection)
    when :groups
      collection = api_client.course_groups(course.canvas_course_id).all_pages!
      sync_groups(collection)
    when :group_memberships
      collection = []
      course.groups.each do |group|
        api_client.list_group_memberships(group.canvas_group_id).all_pages!.each do |group_memberships|
          collection << group_memberships
        end
      end
      sync_group_memberships(collection)
    else
      raise "API METHOD DOESN'T EXIST"
    end
  end

  def delete_removed_records
    course.sections.where.not(id: course_section_ids).destroy_all
    course.enrollments.where.not(id: enrollment_ids).destroy_all
    course.assignments.where.not(id: assignment_ids).destroy_all
    course.groups.where.not(id: group_ids).destroy_all
  end

  def sync_sections(collection)
    collection.each do |values|
      begin
        values['course_section_id'] = values['id'].to_s
        section = course.sections.where(canvas_section_id: values['course_section_id']).first_or_initialize
        section.assign_attributes(standard_attributes(section, values))
        section.sis_id = values['sis_section_id']
        section.save(validate: false)
        course_section_ids << section.id
      rescue => e
        Rails.logger.error "Error syncing sections: #{e}"
      end
    end
  end

  def sync_users(collection)
    collection.each do |values|
      begin
        values['canvas_user_id'] = values["id"].to_s
        user = account.users.where(canvas_user_id: values['canvas_user_id']).first_or_initialize
        user.coalescing_panda_lti_account_id = account.id
        user.assign_attributes(standard_attributes(user, values))
        user.sis_id = values['sis_user_id'].to_s
        user.save(validate: false)
      rescue => e
        Rails.logger.error "Error syncing users: #{e}"
      end
    end
  end

  def sync_enrollments(collection)
    collection.each do |values|
      begin
        values['canvas_enrollment_id'] = values['id'].to_s
        enrollment = course.enrollments.where(canvas_enrollment_id: values['canvas_enrollment_id']).first_or_initialize
        enrollment.section = course.sections.find_by(canvas_section_id: values['course_section_id'].to_s)
        enrollment.user = account.users.find_by(canvas_user_id: values['user_id'].to_s)
        values['workflow_state'] = values["enrollment_state"]
        values['enrollment_type'] = values['type']
        enrollment.assign_attributes(standard_attributes(enrollment, values))
        enrollment.save(validate: false)
        enrollment_ids << enrollment.id
      rescue => e
        Rails.logger.error "Error syncing enrollments: #{e}"
      end
    end
  end

  def sync_assignments(collection)
    collection.each do |values|
      values['canvas_assignment_id'] = values['id'].to_s
      assignment = course.assignments.where(canvas_assignment_id: values['canvas_assignment_id']).first_or_initialize
      assignment.assign_attributes(standard_attributes(assignment, values))
      assignment.save(validate: false)
      assignment_ids << assignment.id
    end
  end

  def sync_submissions(collection)
    collection.each do |values|
      values['canvas_submission_id'] = values['id'].to_s
      submission = course.submissions.where(canvas_submission_id: values['canvas_submission_id']).first_or_initialize
      submission.user = course.users.find_by(canvas_user_id: values['user_id'].to_s)
      submission.assignment = course.assignments.find_by(canvas_assignment_id: values['assignment_id'].to_s)
      submission.assign_attributes(standard_attributes(submission, values))
      submission.save(validate: false)
    end
  end

  def sync_groups(collection)
    collection.each do |values|
      values['canvas_group_id'] = values['id'].to_s
      group = course.groups.where(canvas_group_id: values['canvas_group_id']).first_or_initialize
      group.assign_attributes(standard_attributes(group, values))
      group.save(validate: false)
      group_ids << group.id
    end
  end

  def sync_group_memberships(collection)
    collection.each do |values|
      values['canvas_group_membership_id'] = values['id'].to_s
      group_membership = course.group_memberships.where(canvas_group_membership_id: values['canvas_group_membership_id']).first_or_initialize
      group_membership.group = course.groups.find_by(canvas_group_id: values['group_id'].to_s)
      group_membership.user = course.users.find_by(canvas_user_id: values['user_id'].to_s)
      group_membership.assign_attributes(standard_attributes(group_membership, values))
      group_membership.save(validate: false)
    end
  end

  def standard_attributes(record, attributes)
    new_attributes = attributes.dup
    new_attributes.delete('id')
    new_attributes.delete_if { |key, value| !record.attributes.include?(key) }
  end
end