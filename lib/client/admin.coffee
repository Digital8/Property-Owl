module.exports = ->
  
  $ ->
    ($ '.admin-gridview.deals .add').click (event) ->
      event.preventDefault()
      
      owlId = ($ 'form').data 'id'
      
      $.post "/admin/owls/#{owlId}/deals",
        value: 0
        description: ''
        deal_type_id: 0
      , (res, body, jqXHR) ->      
        
        template = ($ '.template tr').clone()
        
        ($ '.admin-gridview.deals tbody.body').append template
        
        description = template.find '.name'
        description.val ''
        
        value = template.find '[type=number]'
        value.val '0'
        
        form = $ '.form'
        
        id = form.data 'id'
  
  $ ->
    for dealRow in $ '.admin-gridview.deals tr.deal'
      $dealRow = $ dealRow
      
      owlId = ($ 'form').data 'id'
      dealId = $dealRow.data 'id'
      
      deleteButton = $dealRow.find '.delete'
      
      deleteButton.click (event) ->
        event.preventDefault()
        
        $.delete "/admin/owls/#{owlId}/deals/#{dealId}", (response, body, jqXHR) ->
          if jqXHR.status is 200
            $dealRow.remove()
      
  $ ->
    ($ '.admin-gridview.images .add').click (event) ->
      event.preventDefault()
      
      template = ($ '.imgTemplate tr').clone()
      
      ($ '.admin-gridview.images tbody.body').append template
      
      description = template.find('.name')
      description.val ''
      
      value = template.find('[type=number]')
      value.val '5000'