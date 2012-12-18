module.exports = ->
  medias = $ '.media'
  
  for media in medias
    $media = $ media
    
    do (media, $media) ->
      $media.find('.delete').click (event) ->
        event.preventDefault()
        
        $.delete "/medias/#{$media.data 'id'}", ->
          console.log arguments