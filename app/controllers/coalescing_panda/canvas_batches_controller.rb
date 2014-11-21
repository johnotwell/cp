require_dependency "coalescing_panda/application_controller"

module CoalescingPanda
  class CanvasBatchesController < ApplicationController
    def show
      @batch = CanvasBatch.find(params[:id])
      render @batch
    end

    def clear_batch_session
      session[:canvas_batch_id] = nil
      render nothing: true
    end
  end
end
