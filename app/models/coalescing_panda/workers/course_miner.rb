class CoalescingPanda::Workers::CourseMiner
  SUPPORTED_MODELS = [:sections, :users, :enrollments, :assignment_groups, :group_categories, :assignments, :submissions, :groups, :group_memberships] #ORDER MATTERS!!
  COMPLETED_STATUSES = ['Completed', 'Error']
  RUNNING_STATUSES = ['Queued', 'Started']

  attr_accessor :options, :account, :course, :batch, :course_section_ids, :enrollment_ids, :assignment_ids, :assignment_group_ids, :group_ids, :group_membership_ids, :user_ids

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
    @group_membership_ids = []
    @user_ids = []
  end

  def setup_batch
    batch = account.canvas_batches.where(context: course).first
    if batch.present? and RUNNING_STATUSES.include?(batch.status)
      batch
    else
      batch = account.canvas_batches.create(context: course, status: "Queued")
    end
    batch.update_attributes(options: options)
    batch
  end

  def api_client
    @api_client ||= Bearcat::Client.new(prefix: account.settings[:base_url], token: account.settings[:account_admin_api_token])
  end

  def start(forced = false)
    unless forced
      return unless batch.status == 'Queued' # don't start if there is already a running job
      return unless should_download?
    end

    begin
      batch.update_attributes(status: "Started", percent_complete: 0)
      index = 1
      SUPPORTED_MODELS.each do |model_key|
        next unless options.include?(model_key)
        process_api_data(model_key.to_sym)
        percent_complete = (index/(options.count.nonzero? || 1).to_f * 100).round(1)
        batch.update_attributes(percent_complete: percent_complete)
        index += 1
      end
      batch.update_attributes(status: "Completed", percent_complete: 100)
    rescue => e
      batch.update_attributes(status: "Error", message: e.message)
    end
  end
  handle_asynchronously :start

  def should_download?
    return true unless account.settings[:canvas_download_interval].present?
    return true unless last_completed_batch = account.canvas_batches.where(context: course, status: 'Completed').order('updated_at ASC').first
    should_download = last_completed_batch.updated_at < Time.zone.now - account.settings[:canvas_download_interval].minutes
    batch.update_attributes(status: 'Canceled') unless should_download
    should_download
  end

  DEFAULT_PARAMS = { 'per_page' => 100 }.freeze

  def process_api_data(key)
    case key
    when :assignment_groups
      collection = api_client.list_assignment_groups(course.canvas_course_id, DEFAULT_PARAMS).all_pages!
      sync_assignment_groups(collection)
    when :sections
      collection = api_client.course_sections(course.canvas_course_id, DEFAULT_PARAMS).all_pages!
      sync_sections(collection)
    when :users
      collection = api_client.list_course_users(course.canvas_course_id, DEFAULT_PARAMS.merge({'enrollment_state' => enrollment_states})).all_pages!
      sync_users(collection)
    when :enrollments
      collection = api_client.course_enrollments(course.canvas_course_id, DEFAULT_PARAMS.merge({'state' => enrollment_states})).all_pages!
      sync_enrollments(collection)
    when :assignments
      collection = api_client.assignments(course.canvas_course_id, DEFAULT_PARAMS).all_pages!
      sync_assignments(collection)
    when :submissions
      collection = api_client.course_submissions(course.canvas_course_id, DEFAULT_PARAMS).all_pages!
      sync_submissions(collection)
    when :groups
      collection = api_client.course_groups(course.canvas_course_id).all_pages!
      sync_groups(collection)
    when :group_categories
      collection = api_client.list_group_categories('courses', course.canvas_course_id, DEFAULT_PARAMS).all_pages!
      sync_group_categories(collection)
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

  def enrollment_states
    enrollment_state =  ['active', 'invited']
    enrollment_state << 'completed' if @options.include?(:include_complete)
    enrollment_state
  end

  def sync_assignment_groups(collection)
    collection.each do |values|
      begin
        values['canvas_assignment_group_id'] = values['id'].to_s
        assignment_group = course.assignment_groups.where(canvas_assignment_group_id: values['canvas_assignment_group_id']).first_or_initialize
        assignment_group.assign_attributes(standard_attributes(assignment_group, values))
        assignment_group.save(validate: false)
        assignment_group_ids << assignment_group.id
      rescue => e
        Rails.logger.error "Error syncing assignment group: #{values} Error: #{e}"
      end
    end
    delete_collection(course.assignment_groups.where.not(id: assignment_group_ids))
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
        Rails.logger.error "Error syncing section: #{values} Error: #{e}"
      end
    end
    delete_collection(course.sections.where.not(id: course_section_ids))
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
        user_ids << user.id
      rescue => e
        Rails.logger.error "Error syncing user: #{values} Error: #{e}"
      end
    end
    removed_users = course.users.where.not(id: user_ids)
    removed_users.each do |user|
      user.enrollments.each do |enrollment|
        delete_collection(course.submissions.where(coalescing_panda_user_id: enrollment.user.id))
        delete_object(enrollment)
      end
    end
    delete_collection(removed_users)
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
      delete_collection(course.submissions.where(coalescing_panda_user_id: enrollment.user.id))
    end
    delete_collection(removed_enrollments)
  end

  def sync_assignments(collection)
    collection.each do |values|
      begin
        values['canvas_assignment_id'] = values['id'].to_s
        assignment = course.assignments.where(canvas_assignment_id: values['canvas_assignment_id']).first_or_initialize
        assignment_group = course.assignment_groups.find_by(canvas_assignment_group_id: values['assignment_group_id'])
        group_category = course.group_categories.find_by(canvas_group_category_id: values['group_category_id'])
        assignment.coalescing_panda_assignment_group_id = assignment_group.id if assignment_group
        assignment.coalescing_panda_group_category_id = group_category.id if group_category
        assignment.assign_attributes(standard_attributes(assignment, values))
        assignment.save(validate: false)
        assignment_ids << assignment.id
      rescue => e
        Rails.logger.error "Error syncing assignment: #{values} Error: #{e}"
      end
    end
    course.assignments.where.not(id: assignment_ids).each do |assignment|
      delete_collection(assignment.submissions)
      delete_object(assignment)
    end
  end

  def sync_submissions(collection)
    collection.each do |values|
      begin
        values['canvas_submission_id'] = values['id'].to_s
        submission = course.submissions.where(canvas_submission_id: values['canvas_submission_id']).first_or_initialize
        submission.user = course.users.find_by(canvas_user_id: values['user_id'].to_s)
        submission.assignment = course.assignments.find_by(canvas_assignment_id: values['assignment_id'].to_s)
        submission.assign_attributes(standard_attributes(submission, values))
        submission.save(validate: false)
      rescue => e
        Rails.logger.error "Error syncing submission: #{values} Error: #{e}"
      end
    end
  end

  def sync_group_categories(collection)
    collection.each do |values|
      begin
        values['canvas_group_category_id'] = values['id'].to_s
        values.delete('context_type')    #assume only course for now
        category = course.group_categories.where(canvas_group_category_id: values['canvas_group_category_id']).first_or_initialize
        category.assign_attributes(standard_attributes(category, values))
        category.save(validate: false)
      rescue => e
        Rails.logger.error "Error syncing group categories: #{values} Error: #{e.message} -  #{e.backtrace}"
      end
    end
  end

  def sync_groups(collection)
    collection.each do |values|
      begin
        values['canvas_group_id'] = values['id'].to_s
        group = course.groups.where(canvas_group_id: values['canvas_group_id']).first_or_initialize
        group_category = course.group_categories.find_by(canvas_group_category_id: values['group_category_id'])
        if values['leader']
          group.leader = course.users.find_by(canvas_user_id: values['leader']['id'].to_s)
        else
          group.leader = nil
        end
        group.coalescing_panda_group_category_id = group_category.id if group_category
        group.assign_attributes(standard_attributes(group, values))
        group.save(validate: false)
        group_ids << group.id
      rescue => e
        Rails.logger.error "Error syncing group: #{values} Error: #{e}"
      end
    end
    delete_collection(course.groups.where.not(id: group_ids))
  end

  def delete_collection(query, hard_delete = false, field = 'workflow_state')
    if @options.include?(:soft_delete) && !hard_delete
      #failsafe in case something was missed
      begin
        query.reorder('').update_all(field.to_sym => 'deleted')
      rescue => e
        Rails.logger.error("Error deleting with soft delete, attempting hard")
        delete_collection(query, true)
      end
    else
      query.destroy_all
    end
  end

  def delete_object(object, hard_delete = false, field = 'workflow_state')
    if @options.include?(:soft_delete) && !hard_delete
      begin
        object.update_attributes(field.to_sym => 'deleted')
      rescue => e
        Rails.logger.error("Error deleting with soft delete, attempting hard")
        delete_object(object, true)
      end
    else
      object.destroy
    end
  end

  def sync_group_memberships(collection)
    collection.each do |values|
      begin
        values['canvas_group_membership_id'] = values['id'].to_s
        group_membership = course.group_memberships.where(canvas_group_membership_id: values['canvas_group_membership_id']).first_or_initialize
        group_membership.group = course.groups.find_by(canvas_group_id: values['group_id'].to_s)
        group_membership.user = course.users.find_by(canvas_user_id: values['user_id'].to_s)
        group_membership.assign_attributes(standard_attributes(group_membership, values))
        group_membership.save(validate: false)
        group_membership_ids << group_membership.id
      rescue => e
        Rails.logger.error "Error syncing group memebership: #{values} Error: #{e}"
      end
    end
    delete_collection(course.group_memberships.where.not(id: group_membership_ids))
  end

  def standard_attributes(record, attributes)
    new_attributes = attributes.dup
    new_attributes.delete('id')
    new_attributes.delete_if { |key, value| !record.attributes.include?(key) }
  end
end
