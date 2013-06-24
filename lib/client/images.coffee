module.exports = ->
  
  ($ '.admin-gridview.images .add').click (event) ->
    
    event.preventDefault()
    
    template = ($ '.imgTemplate tr').clone()
    
    ($ '.admin-gridview.images tbody.body').append template
    
    description = template.find('.name')
    description.val ''
    
    value = template.find('[type=number]')
    value.val '5000'