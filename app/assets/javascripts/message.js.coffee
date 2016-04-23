@message =
  success: (message) ->
    Messenger().post
      message: message
      type: 'success'
  info: (message) ->
    Messenger().post
      message: message
      type: 'info'
  ajaxFail: (xhr, status, message) ->
    Messenger().post
      message: status + ": " + message
      type: "error"
