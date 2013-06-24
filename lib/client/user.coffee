module.exports = ->
  
  $modal = $ "#users-modal"
  
  $form = $modal.find 'form'
  
  $form.on 'submit', (event) ->
    event.preventDefault()
    (require './ajax')
      url: '/users'
      form: $form
      success: (data, textStatus, jqXHR) ->
        window.location.reload()
  
  $(".show-register").on "click", (event) ->
    
    event.preventDefault()
    
    ($ '#login-modal').fadeOut 150
    
    $modal.fadeIn 150
  
  $loginModal = $ '#login-modal'
  
  $(".show-login").on "click", (event) ->
    
    event.preventDefault()
    
    ($ "#users-modal").hide()
    
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)
      window.location = "/login"
    else
      $loginModal.fadeIn 150

  $(".register-first-name, .register-last-name, .register-email, .register-postcode, .register-password, .register-password2").on "keypress", (event) ->
    if event.keyCode is 13
      $(".register-button").click()