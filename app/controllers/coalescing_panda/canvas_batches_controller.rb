require_dependency "coalescing_panda/application_controller"

module CoalescingPanda
  class CanvasBatchesController < ApplicationController
    def show
      @batch = CanvasBatch.find(params[:id])
      render @batch
    end

    def retrigger
      @batch = CanvasBatch.find(params[:id])
      @batch.status = 'Queued'
      @batch.save
      worker = CoalescingPanda::Workers::CourseMiner.new(@batch.context, @batch.options)
      session[:canvas_batch_id] = worker.batch.id
      worker.start(true)
      redirect_to :back
    end

    def clear_batch_session
      session[:canvas_batch_id] = nil
      render nothing: true
    end
  end
end
