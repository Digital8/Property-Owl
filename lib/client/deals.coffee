module.exports = ->
  
  $form = $ 'form.details-form.deal'
  
  $grid = $ '.admin-gridview.deals'
  
  entity =
    id: $form.data 'id'
    type: $grid.data 'entity_type'
  
  base = "/#{entity.type}s/#{entity.id}/deals"
  
  sync = (row) ->
    
    $row = $ row
    
    deal = id: $row.data 'id'
    
    route = "#{base}/#{deal.id}"
    
    bind = (key) ->
      
      $control = $row.find ".#{key}"
      
      $control.bind 'change keyup input', ->
        
        map = {}
        map[key] = $control.val()
        
        $.patch route, map, ->
    
    bind 'deal_type_id'
    bind 'description'
    bind 'value'
    
    ($row.find '.delete').click (event) ->
      
      event.preventDefault()
      
      $.delete route, (response, body, jqXHR) ->
        row.remove() if jqXHR.status is 200
  
  $grid.find('.add').click (event) ->
    
    event.preventDefault()
    
    $.post base, (res, body, jqXHR) ->
      
      template = ($ '.template tr').clone()
      
      template.appendTo ($grid.find 'tbody.body')
      
      template.data 'id', res.id
      
      (template.find '.name').val ''
      
      (template.find '[type=number]').val 0
      
      sync template
  
  $grid = $ '.admin-gridview.deals'
  
  sync row for row in $grid.find 'tbody tr'
  
  return