$ ->
  ($ '.admin-gridview.deals .add').click (event) ->
    event.preventDefault()
    
    console.log 'click'
    
    template = ($ '.template tr').clone()
    
    ($ '.admin-gridview.deals tbody.body').append template