$ ->
  canvasAuth = (url) ->
    newwindow = window.open(url, "name", "width=700,height=500")
    newwindow.focus() if window.focus
    false

  $('#oauth_btn').bind 'click', ->
    canvasAuth($("input[name='canvas_oauth_url']").val())