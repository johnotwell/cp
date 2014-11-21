module CoalescingPanda
  class CanvasBatch < ActiveRecord::Base
    default_scope { order('created_at DESC') }
  end
end
