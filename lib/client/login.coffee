module.exports = ->
  
  ($ '#login-modal input').keypress (event) ->
    event.preventDefault()
    if event.keyCode is 13
      $(".login-button").click()
  
  $(".login-button").on "click", (event) ->
    
    event.preventDefault()
    
    error = $(".login-error")
    
    $.ajax
      url: "/login"
      type: "post"
      data:
        email: $(".login-email").val()
        password: pass = $(".login-password").val()
        remember: $("#remember").attr("checked")
      error: (jqXHR, textStatus, errorThrown) ->
        error.html "Login Failed, Please try again."
        error.stop().fadeOut(100).fadeIn(350).fadeOut(350).fadeIn(350).fadeOut(350).fadeIn 350
      success: (data, textStatus, jqXHR) ->
        window.location.reload()