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
#             , -> console.log 'posted', arguments