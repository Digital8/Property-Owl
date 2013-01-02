module.exports =->
  
  $(".enquire-button").on "click", (e) ->
    e.preventDefault()
    
    $(".modal-enquiry").fadeToggle()
    
    id = $(this).data("id")
    
    $("#sendEnquiry").on "click", ->
      enquiry = $("#enquiry").val()
      
      $.post "/enquiries",
        entity_id: id
        enquiry: enquiry
      , ->
        $(".modal-enquiry").fadeToggle()