# module.exports = ->
#   for thing in ($ '.listing-summary.affiliate')
    
#     $thing = $ thing
    
#     id = $thing.data 'id'
    
#     do ($thing) ->
      
#       for button in $thing.find('.enquire-button')
        
#         $button = $ button
        
#         do ($button) ->
          
#           $button.click (event) ->
            
#             event.preventDefault()
            
#             $.post '/clicks',
#               resource_id: id
#               type: 'affiliate'
#             , ->

module.exports = ->
  
  grid = $ '.admin-gridview.affiliates'
  
  for row in grid.find 'tbody tr'
    
    $row = $ row
    
    do ($row) ->
      
      $row.find('.delete').click (event) ->
        
        event.preventDefault()
        
        id = $row.data 'id'
        
        $.delete "/admin/affiliates/#{id}", ->
          
          $row.remove()