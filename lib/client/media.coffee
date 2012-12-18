module.exports = ->
  medias = $ '.media'
  
  for media in medias
    $media = $ media
    
    do (media, $media) ->
      $media.find('.delete').click (event) ->
        event.preventDefault()
        
        $.delete "/medias/#{$media.data 'id'}", (response, status, jqXHR) ->
          if jqXHR.status is 200
            do $media.remove
          else
            alert "uh oh! spaghettio!"