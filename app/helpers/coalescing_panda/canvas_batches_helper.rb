module CoalescingPanda
  module CanvasBatchesHelper
    def current_batch
      @current_batch ||= CoalescingPanda::CanvasBatch.find_by_id(session[:canvas_batch_id])
    end
  end
end
