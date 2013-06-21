module.exports = ($) ->
  $.delete = (url, callback = ->) ->
    $.ajax
      url: url
      type: 'POST'
      data: {_method: 'delete'}
      dataType: 'json'
      complete: (jqXHR, textStatus) ->
        callback {}, textStatus, jqXHR
  
  $.patch = (url, data, callback = ->) ->
    
    data._method = 'PATCH'
    
    $.ajax
      url: url
      type: 'POST'
      data: data
      dataType: 'json'
      complete: (jqXHR, textStatus) ->
        callback {}, textStatus, jqXHR
  
  $.fn.serializeObject = ->
    object = {}
    
    array = @serializeArray()
    
    $.each array, ->
      if object[@name]?
        object[@name] = [object[@name]] unless object[@name].push
        object[@name].push @value or ''
      else
        object[@name] = @value or ''
    
    return object
