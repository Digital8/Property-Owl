module.exports = ->
  
  grid = $ '.admin-gridview.news'
  
  for row in grid.find 'tbody tr'
    
    $row = $ row
    
    do ($row) ->
      
      $row.find('.delete').click (event) ->
        
        event.preventDefault()
        
        id = $row.data 'id'
        
        $.delete "/admin/news/#{id}", ->
          
          $row.remove()
          
          console.log args