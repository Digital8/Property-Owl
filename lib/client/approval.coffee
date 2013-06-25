module.exports = ->
  
  approvify = ($grid) ->
    
    entity_type = $grid.data 'entity_type'
    
    for row in $grid.find 'tbody tr'
      
      $row = $ row
      
      do ($row) ->
        
        id = $row.data 'id'
        
        approve = $row.find '.approve'
        
        approve.click (event) ->
          
          event.preventDefault()
          
          $.patch "/#{entity_type}s/#{id}", approved: yes, (body, response, xhr) ->
            
            $row.remove() if xhr.status is 200
  
  approvify ($ '.pending-owls')
  
  approvify ($ '.pending-barns')