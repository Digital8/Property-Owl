module.exports = ->
  rows = $ '.deal-grid tbody tr'
  
  for row in rows
    $row = $ row
    
    do ($row) ->
    
      $deleteAction = $row.find '.delete'
      
      $deleteAction.click (event) ->
        
        event.preventDefault()
        
        id = $row.data 'id'
        
        entity_type = $row.data 'entity_type'
        
        if confirm "Really delete #{entity_type} #{id} ?"
          
          $.delete "/#{entity_type}s/#{id}", ->
            
            $row.remove()