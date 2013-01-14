module.exports = ->
  suffixes = ['pad', 'once', 'twice', 'three times', 'four times', 'five times']
  
  $form = $ 'form'
  
  clone = (count) ->
    id = $form.data 'id'
    
    $.post "/admin/owls/#{id}/clone", count: count, (body, res, jqXHR) ->
      # if jqXHR.status is 200
      # window.location = '/admin/owls'
  
  $range = $ '.clone_range'
  $clone_label = $ '.clone_label'
  $clone_range_label = $ '.clone_range_label'

  $table = $ 'table.clone_table'

  syncView = ($range) ->
    # range
    rangeValue = parseInt $range.val()
    
    label = "Clone owl #{suffixes[rangeValue]}"
    
    $clone_label.text label
    
    $clone_range_label.text rangeValue
    
    # table
    $table.empty()
    
    owl = $form.serializeObject()
    
    owl.id = '?'
    
    schema =
      id: {}
      address: {}
      suburb: {}
      state: {}
    
    $header = $ '<tr>'
    $header.appendTo $table
    
    for key, value of schema
      $th = $ '<th>'
      $th.text key
      $th.appendTo $header
    
    $tbody = $ '<tbody>'
    $tbody.appendTo $table
    
    for i in [0...rangeValue]
      $row = $ '<tr>'
      
      $row.appendTo $tbody
      
      for key, schematic of schema
        $cell = $ '<td>'
        $cell.text owl[key]
        $cell.appendTo $row

  $range.change (event) ->
    syncView $range

  syncView $range
  
  $('.clone_button').click (event) ->
    event.preventDefault()
    
    clone parseInt $range.val()