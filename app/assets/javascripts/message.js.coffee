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
    if xhr.responseJSON && xhr.responseJSON.error_messages
      msgs = xhr.responseJSON.error_messages
      for msg in msgs
        Messenger().post
          message: msg
          type: "error"
    else
      Messenger().post
        message: status + ": " + message
        type: "error"
