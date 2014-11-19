module CoalescingPanda
  class Enrollment < ActiveRecord::Base
    belongs_to :user, foreign_key: :coalescing_panda_user_id, class_name: 'CoalescingPanda::User'
    belongs_to :section, foreign_key: :coalescing_panda_section_id, class_name: 'CoalescingPanda::Section'

    delegate :account, to: :section
  end
end
