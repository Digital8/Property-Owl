module.exports = ->
  
  $ ->
    ($ '.admin-gridview.deals .add').click (event) ->
      event.preventDefault()
      
      template = ($ '.template tr').clone()
      
      ($ '.admin-gridview.deals tbody.body').append template
      
      description = template.find '.name'
      description.val ''
      
      value = template.find '[type=number]'
      value.val '5000'
      
      form = $ '.form'
      
      id = form.data 'id'
  
  $ ->
    # deleteButton = template.find '.delete'
    # deleteButton.click (event) ->
    #   event.preventDefault()
      
    #   $.delete "/admin/owls/#{id}/deals/#{id}", (args...) ->
    #     console.log args
      
  $ ->
    ($ '.admin-gridview.images .add').click (event) ->
      event.preventDefault()
      
      template = ($ '.imgTemplate tr').clone()
      
      ($ '.admin-gridview.images tbody.body').append template
      
      description = template.find('.name')
      description.val ''
      
      value = template.find('[type=number]')
      value.val '5000'