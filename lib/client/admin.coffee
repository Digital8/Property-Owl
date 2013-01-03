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
  
  $ ->
    ($ '.admin-gridview.images .add').click (event) ->
      event.preventDefault()
      
      template = ($ '.imgTemplate tr').clone()
      
      ($ '.admin-gridview.images tbody.body').append template
      
      description = template.find('.name')
      description.val ''
      
      value = template.find('[type=number]')
      value.val '5000'
  
  do require './deals'