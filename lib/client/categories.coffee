module.exports = () ->
  $rows = $ '.categories tbody tr'
  
  for row in $rows
    $row = $ row
    
    id = $row.data 'id'
    
    $row.find('.delete').click (event) ->
      
      event.preventDefault()
      
      $.delete "/categories/#{id}", (res, body, xhr) ->
        
        if xhr.status is 200
          
          $row.fadeOut()