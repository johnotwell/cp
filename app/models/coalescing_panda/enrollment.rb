module CoalescingPanda
  class Enrollment < ActiveRecord::Base
    belongs_to :user, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::User'
    belongs_to :section, foreign_key: :coalescing_panda_section_id, class_name: 'CoalescingPanda::Section'

    delegate :account, to: :section

    validates :coalescing_panda_user_id, presence: true
    validates :coalescing_panda_section_id, presence: true
    validates :canvas_enrollment_id, presence: true
  end
end
