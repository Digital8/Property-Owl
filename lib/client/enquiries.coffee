module.exports = ->
  
  # affiliates
  $(".enquire-button").on "click", (e) ->
    e.preventDefault()
    
    $(".modal-enquiry").fadeToggle()
    
    id = $(this).data("id")
    
    $("#sendEnquiry").on "click", ->
      enquiry = $("#enquiry").val()
      name =  $("#name").val()
      method = $("#method").val()
      phone = $("#phone").val()
      email = $("#email").val()
      
      $.post "/enquiries",
        entity_id: id
        entity_type: 'affiliate'
        enquiry: enquiry
        name: name
        contact: method
        email: email
        phone: phone
      , (data) ->
        if data.status is 200
          $(".modal-enquiry").fadeToggle()
        else
          alert "Uh oh an error occured!"
  
  # owls
  ($ '.enquire').click (event) ->
    
    event.preventDefault()
    
    $form = $ '.enquire-form'
    
    $.post '/enquiries', $form.serialize()
