module.exports = ->
  
  sync = (row) ->
    $type = row.find '.deal_type_id'
    $type.bind 'change keydown input', ->
      
      owlId = ($ 'form').data 'id'
      dealId = row.data 'id'
      
      $.patch "/admin/owls/#{owlId}/deals/#{dealId}",
        deal_type_id: $type.val()
      , ->
    
    $description = row.find '.description'
    $description.bind 'change keydown input', ->
      
      owlId = ($ 'form').data 'id'
      dealId = row.data 'id'
      
      $.patch "/admin/owls/#{owlId}/deals/#{dealId}",
        description: $description.val()
      , ->
    
    $value = row.find '.value'
    $value.bind 'change keydown input', ->
      
      owlId = ($ 'form').data 'id'
      dealId = row.data 'id'
      
      $.patch "/admin/owls/#{owlId}/deals/#{dealId}",
        value: $value.val()
      , ->
    
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
    $form = $ 'form'
    
    $grid = $ '.admin-gridview.deals'
    
    entity_type = $grid.data 'entity_type'
    
    $grid.find('.add').click (event) ->
      event.preventDefault()
      
      entity_id = $form.data 'id'
      
      $.post "/admin/#{entity_type}s/#{entity_id}/deals",
        value: 0
        description: ''
        deal_type_id: 0
      , (res, body, jqXHR) ->
        
        template = ($ '.template tr').clone()
        
        template.appendTo ($grid.find 'tbody.body')
        
        template.data 'id', ($form.data 'id')
        
        template.data 'entity_type', entity_type
        
        description = template.find '.name'
        description.val ''
        
        value = template.find '[type=number]'
        value.val '0'
        
        sync template
  
  $ ->
    $grid = $ '.admin-gridview.deals'
    
    for dealRow in $grid.find 'tbody tr'
      
      $dealRow = $ dealRow
      
      sync $dealRow