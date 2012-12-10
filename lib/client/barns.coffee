module.exports = ->
  $matrix = $ '.owl-matrix'
  
  $results = $ '<table>'
  
  $results.insertAfter $matrix
  
  $form = $ '.details-form'
  
  $address = $form.find '[name=address]'
  
  $suburb = $form.find '[name=suburb]'
  
  update = ->
    $.get "/ajax/search?address=#{$address.val()}&suburb=#{$suburb.val()}", ->
      console.log arguments
  
  $address.bind 'change keydown', ->
    update()
  
  $suburb.bind 'change keydown', ->
    update()