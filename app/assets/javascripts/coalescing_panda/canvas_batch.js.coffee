window.CoalescingPanda or= {}

window.CoalescingPanda.CanvasBatchProgress = class CanvasBatchProgress
  constructor: (successCallback, errorCallback, messages)  ->
    window.messages = messages if messages != undefined
    setFlashMessages()
    batch = $('#batch-progress').data('batch')
    url = $('#batch-progress').data('url')
    window.clearPath = $('#batch-progress').data('clear-path')
    if batch && batch.status != "Completed" || batch.status != "Error"
      window.batchInterval = setInterval(getBatchStatus, 3000, batch.id, url, successCallback, errorCallback)

  getBatchStatus = (id, url, successCallback, errorCallback) ->
    $.ajax
      url: url
      success: (data) ->
        $('#batch-progress').html(data)
        setFlashMessages()
        batch = $('#batch-info').data('batch')
        if batch && batch.status == "Completed"
          clearIntervalAndBatch(data, batch)
          successCallback() if successCallback != undefined
        else if batch && batch.status == 'Error'
          clearIntervalAndBatch(data, batch)
          errorCallback() if errorCallback != undefined
        else if batch && batch.status == "Canceled"
          clearIntervalAndBatch(data, batch)

      error: (message) ->
        $('#batch-progress').html('Batch status request failed')
        clearInterval(window.batchInterval)

  clearBatchFromSession = (id) ->
    $.ajax
      url: window.clearPath
      type: 'POST'
      success: (data) ->
        # Don't need to do anything

  clearIntervalAndBatch = (data, batch) ->
    clearInterval(window.batchInterval)
    $('#batch-progress').html(data)
    setFlashMessages()
    clearBatchFromSession(batch.id)

  setFlashMessages = ->
    if window.messages != undefined
      for key of window.messages
        $(".batch-message-#{key}").text("#{window.messages[key]}")