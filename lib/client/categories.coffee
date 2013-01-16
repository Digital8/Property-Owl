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
  
  $tbody = $ '.categories tbody'
  
  $tfoot = $ '.categories tfoot'
  
  sync = ($trs) ->
    # console.log 'syncing', $trs
    
    for tr in $trs
      $tr = $ tr
      
      id = $tr.data 'id'
      
      $input = $tr.find 'input'
      
      do ($input, id, $tr) ->
      
        $input.bind 'input', (event) ->
          
          # console.log 'change'
          
          $.patch "/categories/#{id}", key: $input.val()
  
  sync $ '.categories tbody tr'