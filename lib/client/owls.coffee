module.exports = ->
  
  change = ->
    deals = $ '.deals .deal'
    
    # for deal in deals
  
  change()
  
  for form in ($ 'form.details-form.owl')
    $form = $ form
    
    id = $form.data 'id'
    
    approved = $form.find('[name=approved]')
    
    approved.change (event) ->
      event.preventDefault()
      
      console.log 'click'
      
      $.patch "/admin/owls/#{id}", approved: approved.is(':checked'), -> console.log arguments 