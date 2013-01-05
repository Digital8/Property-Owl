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
          
          $.patch "/admin/#{entity_type}s/#{id}", approved: yes, (body, response, xhr) ->
            if xhr.status == 200
              $row.remove()
  
  approvify ($ '.pending-owls')
  
  approvify ($ '.pending-barns')