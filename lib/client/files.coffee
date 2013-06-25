module.exports = ->
  
  grid = $ '.admin-gridview.files'
  
  for row in grid.find 'tbody tr'
    
    $row = $ row
    
    do ($row) ->
      
      $row.find('.delete').click (event) ->
        
        event.preventDefault()
        
        id = $row.data 'id'
        
        if confirm('Are you sure you want to remove this?')
	        $.delete "/files/#{id}", ->
	          
	          $row.remove()