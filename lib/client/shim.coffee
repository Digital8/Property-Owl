module.exports = ($) ->
  $.delete = (url, callback = ->) ->
    $.ajax
      url: url
      type: 'POST'
      data:
        _method: 'delete'
      complete: (jqXHR, textStatus) ->
        callback {}, textStatus, jqXHR