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
        <td style='text-align: center;'>#{owl.id}</td>
        <td style='text-align: center;'>#{moment(owl.created_at).format('DD/MM/YYYY')}</td>
        <td>#{owl.title}</td>
        <td>#{owl.address}</td>
        <td style='text-align: center;'>#{owl.state.toUpperCase()}</td>
        <td style='text-align: right;'>#{owl.value} %</td>
        <td class="actions"><a href="#" class="nest"><img src="/images/add.png" /> Add</a></td>
      </tr>
      """
  
  makeListRow = (owl) ->
    barnId = $('.inputs.owl-matrix.search').data('barn-id')
    row = $ """
      <tr data-owl-id="#{owl.id}" data-barn-id="#{barnId}">
        <td style='text-align: center;'>#{owl.id}</td>
        <td style='text-align: center;'>#{moment(owl.created_at).format('DD/MM/YYYY')}</td>
        <td>#{owl.title}</td>
        <td>#{owl.address}</td>
        <td style='text-align: center;'>#{owl.state.toUpperCase()}</td>
        <td style='text-align: right;'>#{owl.value} %</td>
        <td class="actions"><a href="#" class="unnest"><img src="/images/delete.png" />Remove</a></td>
      </tr>
      """
  
  update = ->
    
    $.get "/ajax/search?address=#{$address.val()}&suburb=#{$suburb.val()}", ([error, owls]) ->
      
      table = $ '.owl-matrix.search'
      barnId = table.data 'barn-id'
      
      tbody = $ '.owl-matrix.search tbody'
      tbody.empty()
      
      for owl in owls then do (owl) ->
        if not owl.barn_id
          row = makeRow owl
          row.appendTo tbody
          
          row.find('.nest').click (event) ->
            event.preventDefault()
            p = $(this)
            
            $.post "/barns/#{barnId}/owls", id: owl.id,
              row = makeListRow owl
              row.appendTo $('.owl-matrix.nested tbody')
              p.parent().parent().remove()

              do (row) ->
                $row = $ row
                $row.find('.unnest').click (event) ->
                  event.preventDefault()

                  barnId = $row.data 'barn-id'
                  owlId = $row.data 'owl-id'

                  if barnId? and owlId?
                    $.delete "/barns/#{barnId}/owls/#{owlId}", ->
                      $row.remove()
                      update()
        else
          console.log 'Owl is Already in a Barn', owl

  
  $address.bind 'change keyup', ->
    update()
  
  $suburb.bind 'change keyup', ->
    update()
  
  matrix = $ '.owl-matrix'
  
  do update if matrix.length
  
  for row in $('.owl-matrix .owl') then do (row) ->
    $row = $ row
    
    $row.find('.unnest').click (event) ->
      event.preventDefault()
      
      barnId = $row.data 'barn-id'
      owlId = $row.data 'owl-id'

      if barnId? and owlId?
        $.delete "/barns/#{barnId}/owls/#{owlId}", ->
          $row.remove()
          update()
