module.exports = ->
  
  suffixes = ['pad', 'once', 'twice', 'three times', 'four times', 'five times']
  
  suffix = (count) ->
    
    suffixes[count]
  
  $form = $ '.owl.details-form'
  
  clone = (count) ->
    
    id = $form.data 'id'
    
    $.post "/owls/#{id}/clone", count: count, (body, res, jqXHR) ->
      if jqXHR.status is 200
        window.location = '/owls'
  
  $range = $ '.clone_input'
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
    
    console.log rangeValue
    console.count 'wtf'
    for i in [0...rangeValue]
      $row = $ '<tr>'
      
      $row.appendTo $tbody
      
      for key, schematic of schema
        $cell = $ '<td>'
        $cell.text owl[key]
        $cell.appendTo $row
    
    if rangeValue >= 1
      $button.show()
      $button.text "Clone Owl #{suffix rangeValue}"
    else
      $button.hide()

  $range.change (event) ->
    syncView $range
  
  $button = $ '<button>'
  $button.appendTo $ '.pane.clone'
  $button.hide()
  
  syncView $range
  
  $button.click (event) ->
    
    event.preventDefault()
    
    clone parseInt $range.val()