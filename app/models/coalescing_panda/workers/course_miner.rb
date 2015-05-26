class CoalescingPanda::Workers::CourseMiner
  SUPPORTED_MODELS = [:sections, :users, :enrollments, :assignment_groups, :assignments, :submissions, :groups, :group_memberships] #ORDER MATTERS!!
  COMPLETED_STATUSES = ['Completed', 'Error']
  RUNNING_STATUSES = ['Queued', 'Started']

  attr_accessor :options, :account, :course, :batch, :course_section_ids, :enrollment_ids, :assignment_ids, :assignment_group_ids, :group_ids, :user_ids

  def initialize(course, options = [])
    @course = course
    @account = course.account
    @options = options
    @batch = setup_batch
    @course_section_ids = []
    @enrollment_ids = []
    @assignment_ids = []
    @assignment_group_ids = []
    @group_ids = []
    @user_ids = []
  end

  def setup_batch
    batch = account.canvas_batches.where(context: course).first
    if batch.present? and RUNNING_STATUSES.include?(batch.status)
      batch
    else
      account.canvas_batches.create(context: course, status: "Queued")
    end
  end

  def api_client
    @api_client ||= Bearcat::Client.new(prefix: account.settings[:base_url], token: account.settings[:account_admin_api_token])
  end

  def start
    return unless batch.status == 'Queued'
    begin
      batch.update_attributes(status: "Started", percent_complete: 0)
      SUPPORTED_MODELS.each_with_index do |model_key, index|
        index += 1
        process_api_data(model_key.to_sym) if options.include?(model_key)
        percent_complete = (index/(options.count.nonzero? || 1).to_f * 100).round(1)
        batch.update_attributes(percent_complete: percent_complete)
      end
      batch.update_attributes(status: "Completed", percent_complete: 100)
    rescue => e
      batch.update_attributes(status: "Error", message: e.message)
    end
  end
  handle_asynchronously :start

  def process_api_data(key)
    case key
    when :assignment_groups
      collection = api_client.list_assignment_groups(course.canvas_course_id).all_pages!
      sync_assignment_groups(collection)
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

  def sync_assignment_groups(collection)
    begin
      collection.each do |values|
        values['canvas_assignment_group_id'] = values['id'].to_s
        assignment_group = course.assignment_groups.where(canvas_assignment_group_id: values['canvas_assignment_group_id']).first_or_initialize
        assignment_group.assign_attributes(standard_attributes(assignment_group, values))
        assignment_group.save(validate: false)
        assignment_group_ids << assignment_group.id
      end
      course.assignment_groups.where.not(id: assignment_group_ids).destroy_all
    rescue => e
      Rails.logger.error "Error syncing assignment groups: #{e}"
    end
  end

  def sync_sections(collection)
    begin
      collection.each do |values|
        values['course_section_id'] = values['id'].to_s
        section = course.sections.where(canvas_section_id: values['course_section_id']).first_or_initialize
        section.assign_attributes(standard_attributes(section, values))
        section.sis_id = values['sis_section_id']
        section.save(validate: false)
        course_section_ids << section.id
      end
      course.sections.where.not(id: course_section_ids).destroy_all
    rescue => e
      Rails.logger.error "Error syncing sections: #{e}"
    end
  end

  def sync_users(collection)
    begin
      collection.each do |values|
        values['canvas_user_id'] = values["id"].to_s
        user = account.users.where(canvas_user_id: values['canvas_user_id']).first_or_initialize
        user.coalescing_panda_lti_account_id = account.id
        user.assign_attributes(standard_attributes(user, values))
        user.sis_id = values['sis_user_id'].to_s
        user_ids << user.id
        user.save(validate: false)
      end
      removed_users = course.users.where.not(id: user_ids)
      removed_users.each do |user|
        user.enrollments.each do |enrollment|
          course.submissions.where(coalescing_panda_user_id: enrollment.user.id).destroy_all
          enrollment.destroy
        end
      end
      removed_users.destroy_all
    rescue => e
      Rails.logger.error "Error syncing users: #{e}"
    end
  end

  def sync_enrollments(collection)
    collection.each do |values|
      begin
        values['canvas_enrollment_id'] = values['id'].to_s
        section = course.sections.find_by(canvas_section_id: values['course_section_id'].to_s)
        enrollment = section.enrollments.where(canvas_enrollment_id: values['canvas_enrollment_id']).first_or_initialize
        enrollment.section = course.sections.find_by(canvas_section_id: values['course_section_id'].to_s)
        enrollment.user = account.users.find_by(canvas_user_id: values['user_id'].to_s)
        values['workflow_state'] = values["enrollment_state"]
        values['enrollment_type'] = values['type']
        enrollment.assign_attributes(standard_attributes(enrollment, values))
        enrollment.save!(validate: false)
        enrollment_ids << enrollment.id
      rescue => e
        Rails.logger.error "Error syncing enrollment: #{values} Error: #{e}"
      end
    end
    removed_enrollments = course.enrollments.where.not(id: enrollment_ids)
    removed_enrollments.each do |enrollment|
      course.submissions.where(coalescing_panda_user_id: enrollment.user.id).destroy_all
    end
    removed_enrollments.destroy_all
  end

  def sync_assignments(collection)
    begin
      collection.each do |values|
        values['canvas_assignment_id'] = values['id'].to_s
        assignment = course.assignments.where(canvas_assignment_id: values['canvas_assignment_id']).first_or_initialize
        assignment_group = course.assignment_groups.find_by(canvas_assignment_group_id: values['assignment_group_id'])
        assignment.coalescing_panda_assignment_group_id = assignment_group.id if assignment_group
        assignment.assign_attributes(standard_attributes(assignment, values))
        assignment.save(validate: false)
        assignment_ids << assignment.id
      end
      course.assignments.where.not(id: assignment_ids).each do |assignment|
        assignment.submissions.destroy_all
        assignment.destroy!
      end
    rescue => e
      Rails.logger.error "Error syncing assignments: #{e}"
    end
  end

  def sync_submissions(collection)
    begin
      collection.each do |values|
        values['canvas_submission_id'] = values['id'].to_s
        submission = course.submissions.where(canvas_submission_id: values['canvas_submission_id']).first_or_initialize
        submission.user = course.users.find_by(canvas_user_id: values['user_id'].to_s)
        submission.assignment = course.assignments.find_by(canvas_assignment_id: values['assignment_id'].to_s)
        submission.assign_attributes(standard_attributes(submission, values))
        submission.save(validate: false)
      end
    rescue => e
      Rails.logger.error "Error syncing submissions: #{e}"
    end
  end

  def sync_groups(collection)
    begin
      collection.each do |values|
        values['canvas_group_id'] = values['id'].to_s
        group = course.groups.where(canvas_group_id: values['canvas_group_id']).first_or_initialize
        group.assign_attributes(standard_attributes(group, values))
        group.save(validate: false)
        group_ids << group.id
      end
      course.groups.where.not(id: group_ids).destroy_all
    rescue => e
      Rails.logger.error "Error syncing groups: #{e}"
    end
  end

  def sync_group_memberships(collection)
    begin
      collection.each do |values|
        values['canvas_group_membership_id'] = values['id'].to_s
        group_membership = course.group_memberships.where(canvas_group_membership_id: values['canvas_group_membership_id']).first_or_initialize
        group_membership.group = course.groups.find_by(canvas_group_id: values['group_id'].to_s)
        group_membership.user = course.users.find_by(canvas_user_id: values['user_id'].to_s)
        group_membership.assign_attributes(standard_attributes(group_membership, values))
        group_membership.save(validate: false)
      end
    rescue => e
      Rails.logger.error "Error syncing group memberships: #{e}"
    end
  end

  def standard_attributes(record, attributes)
    new_attributes = attributes.dup
    new_attributes.delete('id')
    new_attributes.delete_if { |key, value| !record.attributes.include?(key) }
  end
end