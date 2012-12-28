```coffee
module.exports = ($) ->
  $.delete = (url, callback = ->) ->
    $.ajax
      url: url
      type: 'POST'
      data: {_method: 'delete'}
      complete: (jqXHR, textStatus) ->
        callback {}, textStatus, jqXHR
  
  $.patch = (url, data, callback = ->) ->
    data._method = 'patch'
    
    $.ajax
      url: url
      type: 'POST'
      data: data
      complete: (jqXHR, textStatus) ->
        callback {}, textStatus, jqXHR
```