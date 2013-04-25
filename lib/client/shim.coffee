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
