module.exports = ->
  
  # affiliates
  processing = false
  $(".enquire-button").on "click", (e) ->
    e.preventDefault()
    
    $(".modal-enquiry").fadeToggle()
    
    id = $(this).data("id")
    
    $('.close-modal-enquiry').click ->
      $('.modal-enquiry').hide()


    $("#sendEnquiry").on "click", ->
      
      if not processing
        processing = true
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
          processing = false
          if data.status is 200
            $(".modal-enquiry").hide()
          else
            alert 'An error occured'
  
  # owls
  ($ '.enquire').click (event) ->
    
    event.preventDefault()
    
    $form = $ '.enquire-form'
    console.log $form
    $.post '/enquiries', $form.serialize(), (data) ->
      if data.status is 200
        alert 'Enquiry sent!'
      else
        alert 'Internal error sending email. Please try again later.'
