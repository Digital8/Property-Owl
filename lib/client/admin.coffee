module.exports = ->
  
  grid = $ '.admin-gridview.pending-owls'
  
  for row in grid.find 'tbody tr'
    $row = $ row
    do ($row) ->
      id = $row.data 'id'
      
      approve = $row.find '.approve'
      
      approve.click (event) ->
        event.preventDefault()
        
        $.patch "/admin/owls/#{id}", approved: yes, (body, response, xhr) ->
          if xhr.status == 200
            $row.remove()
  
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