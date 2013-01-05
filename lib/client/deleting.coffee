module.exports = ->
  rows = $ '.owl-grid tbody tr'
  
  for row in rows
    $row = $ row
    
    do ($row) ->
    
      $deleteAction = $row.find '.delete'
      
      $deleteAction.click (event) ->
        
        event.preventDefault()
        
        id = $row.data 'id'
        
        r = confirm "Really delete Owl #{id} ?"
        
        if r
        
          $.delete "/admin/owls/#{id}", ->
            
            $row.remove()