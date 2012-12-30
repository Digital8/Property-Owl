module.exports = ->
  
  sync = (row) ->
    $type = row.find '.deal_type_id'
    $type.bind 'change keydown input', ->
      
      owlId = ($ 'form').data 'id'
      dealId = row.data 'id'
      
      $.patch "/admin/owls/#{owlId}/deals/#{dealId}",
        deal_type_id: $type.val()
      , -> console.log arguments...
    
    $description = row.find '.description'
    $description.bind 'change keydown input', ->
      
      owlId = ($ 'form').data 'id'
      dealId = row.data 'id'
      
      $.patch "/admin/owls/#{owlId}/deals/#{dealId}",
        description: $description.val()
      , -> console.log arguments...
    
    $value = row.find '.value'
    $value.bind 'change keydown input', ->
      
      owlId = ($ 'form').data 'id'
      dealId = row.data 'id'
      
      $.patch "/admin/owls/#{owlId}/deals/#{dealId}",
        value: $value.val()
      , -> console.log arguments...
    
    # delete
    owlId = ($ 'form').data 'id'
    dealId = row.data 'id'
    
    deleteButton = row.find '.delete'
    
    deleteButton.click (event) ->
      event.preventDefault()
      
      $.delete "/admin/owls/#{owlId}/deals/#{dealId}", (response, body, jqXHR) ->
        if jqXHR.status is 200
            row.remove()
  
  $ ->
    ($ '.admin-gridview.deals .add').click (event) ->
      event.preventDefault()
      
      owlId = ($ 'form').data 'id'
      
      $.post "/admin/owls/#{owlId}/deals",
        value: 0
        description: ''
        deal_type_id: 0
      , (res, body, jqXHR) ->      
        
        console.log 'res', res
        
        template = ($ '.template tr').clone()
        
        ($ '.admin-gridview.deals tbody.body').append template
        
        description = template.find '.name'
        description.val ''
        
        value = template.find '[type=number]'
        value.val '0'
        
        form = $ '.form'
        
        id = form.data 'id'
        
        template.data 'id', res.id
        
        sync template
  
  $ ->
    for dealRow in $ '.admin-gridview.deals tr.deal'
      $dealRow = $ dealRow
      
      sync $dealRow
      
  $ ->
    ($ '.admin-gridview.images .add').click (event) ->
      event.preventDefault()
      
      template = ($ '.imgTemplate tr').clone()
      
      ($ '.admin-gridview.images tbody.body').append template
      
      description = template.find('.name')
      description.val ''
      
      value = template.find('[type=number]')
      value.val '5000'