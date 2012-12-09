$ ->
  ($ '.admin-gridview.deals .add').click (event) ->
    event.preventDefault()
    
    console.log 'click'
    
    template = ($ '.template tr').clone()
    
    ($ '.admin-gridview.deals tbody.body').append template
    
    description = template.find('.name')
    description.val ''
    
    value = template.find('[type=number]')
    value.val '0'
    
$ ->
  ($ '.admin-gridview.images .add').click (event) ->
    event.preventDefault()
    
    template = ($ '.imgTemplate tr').clone()
    
    ($ '.admin-gridview.images tbody.body').append template
    
    description = template.find('.name')
    description.val ''
    
    value = template.find('[type=number]')
    value.val '0'