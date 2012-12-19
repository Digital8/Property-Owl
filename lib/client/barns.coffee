moment = require 'moment'

module.exports = ->
  $matrix = $ '.owl-matrix'
  
  $results = $ '<table>'
  
  $results.insertAfter $matrix
  
  $form = $ '.details-form'
  
  $address = $form.find '[name=address]'
  
  $suburb = $form.find '[name=suburb]'
  
  makeRow = (owl) ->
    row = $ """
      <tr>
        <td>#{owl.id}</td>
        <td>#{moment(owl.created_at).format('L')}</td>
        <td>#{owl.title}</td>
        <td>#{owl.address}</td>
        <td>#{owl.state.toUpperCase()}</td>
        <td>Active</td>
        <td>#{owl.value}</td>
        <td>#{owl.registrations}</td>
        <td><a href="#" class="nest"><img src="/images/add.png" /> Nest</a></td>
      </tr>
      """
  
  makeListRow = (owl) ->
    row = $ """
      <tr>
        <td>#{owl.id}</td>
        <td>#{moment(owl.created_at).format('L')}</td>
        <td>#{owl.title}</td>
        <td>#{owl.address}</td>
        <td>#{owl.state.toUpperCase()}</td>
        <td>Active</td>
        <td>#{owl.value}</td>
        <td>#{owl.registrations}</td>
        <td><a href="#" class="nest"><img src="/images/edit.png" /> Un-Nest</a></td>
      </tr>
      """
  
  update = ->
    $.get "/ajax/search?address=#{$address.val()}&suburb=#{$suburb.val()}", ([error, owls]) ->
      # console.log arguments
      
      console.log 'error', error
      
      console.log 'owls', owls
      
      table = $ '.owl-matrix.search'
      barnId = table.data 'barn-id'
      
      tbody = $ '.owl-matrix.search tbody'
      tbody.empty()
      
      for owl in owls then do (owl) ->
        console.log owl
        
        row = makeRow owl
        row.appendTo tbody
        
        row.find('.nest').click (event) ->
          event.preventDefault()
          
          $.post "/admin/barns/#{barnId}/owls", {id: owl.id},
            # (-> console.log arguments)
            row = makeListRow owl
            row.appendTo $('.owl-matrix tbody')
  
  $address.bind 'change keydown', ->
    update()
  
  $suburb.bind 'change keydown', ->
    update()
  
  do update
  
  for row in $('.owl-matrix .owl')
    $row = $ row
    
    do ($row, row) ->
      
      $row.find('.unnest').click (event) ->
        event.preventDefault()
        
        barnId = $row.data 'barn-id'
        owlId = $row.data 'owl-id'
        
        console.log barnId
        
        $.delete "/admin/barns/#{barnId}/owls/#{owlId}", ->
          console.log arguments
          
          $row.remove()