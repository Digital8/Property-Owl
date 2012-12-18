medias = $ '.media'

for media in medias
  $media = media
  
  do (media, $media) ->
    $media.find('.delete').click ->
      $.delete "/medias/#{$media.data 'id'}", ->
        console.log arguments