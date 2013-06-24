module.exports = ->
  
  $(".login-button").on "click", (event) ->
    
    event.preventDefault()
    
    email = $(".login-email").val()
    pass = $(".login-password").val()
    error = $(".login-error")
    
    $.ajax
      url: "/ajax/login"
      type: "post"
      data: "e=" + email + "&p=" + pass + "&r=" + $("#remember").attr("checked")
      error: (jqXHR, textStatus, errorThrown) ->
        error.html "Login Failed, Please try again."
        error.stop().fadeOut(100).fadeIn(350).fadeOut(350).fadeIn(350).fadeOut(350).fadeIn 350
      success: (data, textStatus, jqXHR) ->
        window.location.reload()