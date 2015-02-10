module CoalescingPanda
  class CanvasBatch < ActiveRecord::Base
    belongs_to :context, polymorphic: true
    default_scope { order('created_at DESC') }
  end
end
