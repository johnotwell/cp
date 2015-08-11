class Course < CoalescingPanda::Course
  belongs_to :account, foreign_key: :coalescing_panda_lti_account_id, class_name: 'Account'
  belongs_to :term, foreign_key: :coalescing_panda_term_id, class_name: 'Term'
  has_many :sections, foreign_key: :coalescing_panda_course_id, class_name: 'Section'
  has_many :enrollments, through: :sections, class_name: 'Enrollment'
  has_many :assignments, foreign_key: :coalescing_panda_course_id, class_name: 'Assignment'
  has_many :submissions, through: :assignments, class_name: 'Submission'
  has_many :users, through: :sections, class_name: 'User'
end