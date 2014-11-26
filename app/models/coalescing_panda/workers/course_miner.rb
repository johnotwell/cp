class CoalescingPanda::Workers::CourseMiner
  SUPPORTED_MODELS = [:sections, :users, :enrollments, :assignments, :submissions] #ORDER MATTERS!!

  attr_accessor :options, :account, :course, :batch

  def initialize(course, options = [])
    @course = course
    @account = course.account
    @options = options
    @batch = CoalescingPanda::CanvasBatch.create(status: "Queued")
  end

  def api_client
    @api_client ||= Bearcat::Client.new(prefix: account.settings[:base_url], token: account.settings[:account_admin_api_token])
  end

  def start
    begin
      batch.update_attributes(status: "Started", percent_complete: 0)
      SUPPORTED_MODELS.each_with_index do |model_key, index|
        index += 1
        canvas_model_data(api_method(model_key.to_sym), model_key) if options.include?(model_key)
        percent_complete = (index/(options.count.nonzero? || 1).to_f * 100).round(1)
        batch.update_attributes(percent_complete: percent_complete)
      end
      batch.update_attributes(status: "Completed", percent_complete: 100)
    rescue => e
      batch.update_attributes(status: "Error", message: e.message)
    end
  end
  handle_asynchronously :start

  def api_method(key)
    case key
    when :users
      :list_course_users
    when :sections
      :course_sections
    when :enrollments
      :course_enrollments
    when :assignments
      :assignments
    when :submissions
      :get_course_submissions
    else
      raise "API METHOD DOESN'T EXIST"
    end
  end

  def canvas_model_data(method, model_key)
    if model_key == :submissions
      collection = []
      course.assignments.each do |assignment|
        api_client.get_course_submissions(course.canvas_course_id, assignment.canvas_assignment_id).all_pages!.each do |submissions|
          collection << submissions
        end
      end
      create_records(collection, model_key)
    else
      collection = api_client.send(method, course.canvas_course_id).all_pages!
      create_records(collection, model_key)
    end
  end

  def create_records(collection, model_key)
    model = "CoalescingPanda::#{model_key.to_s.singularize.titleize}".constantize
    collection.each do |values|
      canvas_id_key = "canvas_#{model_key.to_s.singularize}_id"
      values[canvas_id_key] = values["id"]
      values['workflow_state'] = values["enrollment_state"] if values.has_key?('enrollment_state')
      values['enrollment_type'] = values['type'] if model_key == :enrollments
      if model_key == :users
        record = account.send(model_key).where("#{canvas_id_key} = ?", values['id'].to_s).first_or_initialize
      else
        record = course.send(model_key).where("#{canvas_id_key} = ?", values['id'].to_s).first_or_initialize
      end
      record.coalescing_panda_lti_account_id = account.id if record.respond_to?(:coalescing_panda_lti_account_id)
      record.assign_attributes(standard_attributes(record, values))
      record.sis_id = sis_id(model_key, values) if record.respond_to?(:sis_id)
      create_associations(record, model_key, values)
      record.save(validate: false)
    end
  end

  def standard_attributes(record, attributes)
    new_attributes = attributes.dup
    new_attributes.delete('id')
    new_attributes.delete_if { |key, value| !record.attributes.include?(key) }
  end

  def sis_id(model_key, values)
    return values['sis_source_id'] if values.has_key?('sis_source_id')
    return values['sis_section_id'] if model_key == :sections
  end

  def create_associations(record, model_key, values)
    case model_key
    when :users
      record.account = account
    when :enrollments
      record.user = account.users.where(canvas_user_id: values['user_id'].to_s).first
      record.section = course.sections.where(canvas_section_id: values['course_section_id'].to_s).first
    when :assignments
      record.course = course
    when :submissions
      record.user = account.users.where(canvas_user_id: values['user_id'].to_s).first
      record.assignment = course.assignments.where(canvas_assignment_id: values['assignment_id'].to_s).first
    end
  end
end