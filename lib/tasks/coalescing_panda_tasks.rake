namespace :coalescing_panda do
  desc "creates model files with the proper associations"
  task :create_models => :environment do
    ### Account.rb
    if File.exist?("#{Rails.root}/app/models/account.rb")
      puts "Skipping account.rb: File already exists"
    else
      file_contents = model_template("Account", "LtiAccount", [
        {type: 'has_many', name: :terms, foreign_key: :coalescing_panda_lti_account_id , class_name: 'Term'},
        {type: 'has_many', name: :courses, foreign_key: :coalescing_panda_lti_account_id, class_name: 'Course'},
        {type: 'has_many', name: :users, foreign_key: :coalescing_panda_lti_account_id, class_name: 'User'}
      ])
      File.open("#{Rails.root}/app/models/account.rb", 'w') {|f| f.write(file_contents) }
    end

    ### Assignment.rb
    if File.exist?("#{Rails.root}/app/models/assignment.rb")
      puts "Skipping assignment.rb: File already exists"
    else
      file_contents = model_template("Assignment", "Assignment", [
        {type: 'belongs_to', name: :course, foreign_key: :coalescing_panda_course_id , class_name: 'Course'},
        {type: 'has_many', name: :submissions, foreign_key: :coalescing_panda_assignment_id, class_name: 'Submission'},
      ])
      File.open("#{Rails.root}/app/models/assignment.rb", 'w') {|f| f.write(file_contents) }
    end

    ### Course.rb
    if File.exist?("#{Rails.root}/app/models/course.rb")
      puts "Skipping course.rb: File already exists"
    else
      file_contents = model_template("Course", "Course", [
        {type: 'belongs_to', name: :account, foreign_key: :coalescing_panda_lti_account_id , class_name: 'Account'},
        {type: 'belongs_to', name: :term, foreign_key: :coalescing_panda_term_id , class_name: 'Term'},
        {type: 'has_many', name: :sections, foreign_key: :coalescing_panda_course_id, class_name: 'Section'},
        {type: 'has_many', name: :enrollments, through: :sections, class_name: "Enrollment"},
        {type: 'has_many', name: :assignments, foreign_key: :coalescing_panda_course_id, class_name: 'Assignment'},
        {type: 'has_many', name: :submissions, through: :assignments, class_name: "Submission"},
        {type: 'has_many', name: :users, through: :sections, class_name: 'User'},
      ])

      File.open("#{Rails.root}/app/models/course.rb", 'w') {|f| f.write(file_contents) }
    end

    ### Enrollment.rb
    if File.exist?("#{Rails.root}/app/models/enrollment.rb")
      puts "Skipping enrollment.rb: File already exists"
    else
      file_contents = model_template("Enrollment", "Enrollment", [
        {type: 'belongs_to', name: :user, foreign_key: :coalescing_panda_user_id , class_name: 'User'},
        {type: 'belongs_to', name: :section, foreign_key: :coalescing_panda_section_id , class_name: 'Section'},
      ])

      File.open("#{Rails.root}/app/models/enrollment.rb", 'w') {|f| f.write(file_contents) }
    end

    ### Section.rb
    if File.exist?("#{Rails.root}/app/models/section.rb")
      puts "Skipping section.rb: File already exists"
    else
      file_contents = model_template("Section", "Section", [
        {type: 'belongs_to', name: :course, foreign_key: :coalescing_panda_course_id , class_name: 'Course'},
        {type: 'has_many', name: :enrollments, foreign_key: :coalescing_panda_section_id , class_name: 'Enrollment'},
        {type: 'has_many', name: :users, through: :enrollments, class_name: 'User'},
      ])

      File.open("#{Rails.root}/app/models/section.rb", 'w') {|f| f.write(file_contents) }
    end

    ### Submission.rb
    if File.exist?("#{Rails.root}/app/models/submission.rb")
      puts "Skipping submission.rb: File already exists"
    else
      file_contents = model_template("Submission", "Submission", [
        {type: 'belongs_to', name: :user, foreign_key: :coalescing_panda_user_id , class_name: 'User'},
        {type: 'belongs_to', name: :assignment, foreign_key: :coalescing_panda_assignment_id , class_name: 'Assignment'},
      ])

      File.open("#{Rails.root}/app/models/submission.rb", 'w') {|f| f.write(file_contents) }
    end

    ### Term.rb
    if File.exist?("#{Rails.root}/app/models/term.rb")
      puts "Skipping term.rb: File already exists"
    else
      file_contents = model_template("Term", "Term", [
        {type: 'belongs_to', name: :account, foreign_key: :coalescing_panda_lti_account_id , class_name: 'Account'},
        {type: 'has_many', name: :courses, foreign_key: :coalescing_panda_term_id , class_name: 'Course'},
      ])

      File.open("#{Rails.root}/app/models/term.rb", 'w') {|f| f.write(file_contents) }
    end

    ### User.rb
    if File.exist?("#{Rails.root}/app/models/user.rb")
      puts "Skipping user.rb: File already exists"
    else
      file_contents = model_template("User", "User", [
        {type: 'belongs_to', name: :account, foreign_key: :coalescing_panda_lti_account_id , class_name: 'Account'},
        {type: 'has_many', name: :enrollments, foreign_key: :coalescing_panda_user_id , class_name: 'Enrollment'},
        {type: 'has_many', name: :submissions, foreign_key: :coalescing_panda_user_id , class_name: 'Submission'},
        {type: 'has_many', name: :sections, through: :enrollments, class_name: 'Section'},
        {type: 'has_many', name: :courses, through: :sections, class_name: 'Course'},
      ])

      File.open("#{Rails.root}/app/models/user.rb", 'w') {|f| f.write(file_contents) }
    end

    ### CanvasBatch.rb
    if File.exist?("#{Rails.root}/app/models/canvas_batch.rb")
      puts "Skipping canvas_batch.rb: File already exists"
    else
      file_contents = model_template("CanvasBatch", "CanvasBatch", [])
      File.open("#{Rails.root}/app/models/canvas_batch.rb", 'w') {|f| f.write(file_contents) }
    end
  end

  def model_template(model_name, coalescing_panda_model_name, associations = [])
    string = ""
    string << "class #{model_name} < CoalescingPanda::#{coalescing_panda_model_name}\n"
    string << associations_string(associations)
    string << "end"
    string
  end

  def associations_string(associations)
    results = ""
    associations.each do |association|
      if association.has_key?(:through)
        results << "  #{association[:type]} :#{association[:name]}, through: :#{association[:through]}, class_name: '#{association[:class_name]}'\n"
      else
        results << "  #{association[:type]} :#{association[:name]}, foreign_key: :#{association[:foreign_key]}, class_name: '#{association[:class_name]}'\n"
      end
    end
    results
  end

end