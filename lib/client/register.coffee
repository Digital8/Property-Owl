module.exports = ->
  
  $ ->
    
    doInterest = (obj) ->
      
      type = obj.data("type")
      
      id = obj.data("id")
      
      $.ajax(
        url: "/ajax/addRegistration"
        method: "GET"
        data: "id=" + id + "&type=" + type
      ).done (d) ->
        console.log d
        if d.status is 200
          $(".overlay").hide()
        else
          $(".overlay").hide()
    
    # Secure Deal
    processing = false
    $(".secure-deal-button").on "click", (event) ->
      firstName = $(".secure-deal-first-name").val()
      lastName = $(".secure-deal-last-name").val()
      email = $(".secure-deal-email").val()
      mobile = $(".secure-deal-phone").val()
      comment = $(".secure-deal-comment").val()
      id = $(".express-button").data("id")
      type = $(".express-button").data("type")
      unless processing
        processing = true
        $.ajax(
          url: "/ajax/securedeal"
          type: "post"
          data: "id=" + id + "&type=" + type + "&e=" + email + "&m=" + mobile + "&f=" + firstName + "&l=" + lastName + "&c=" + comment
        ).done (d) ->
          processing = false
          if d.status is 200
            $(".secure-deal-errors").html "Message Sent!"
            $(".secure-deal-comment").val ""
            doInterest $(".express-button")
          else
            errors = Object.keys(d.errors)
            $("#generic-modal, #generic-modal .modal.main").removeClass "success"
            $("#generic-modal-title").html "Please fix the following"
            $("#generic-modal-content").html "<br /><ul>"
            i = 0
            while i < errors.length
              $("#generic-modal-content").append "<li><b>" + d.errors[errors[i]].msg + "</b></li>"
              i++
            $("#generic-modal-content").append "</ul>"
            $("#generic-modal").fadeToggle 150

        false
