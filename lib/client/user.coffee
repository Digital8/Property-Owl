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
  
  $(".show-register, .close-register").on "click", (event) ->
    event.preventDefault()
    ('#login-modal').hide()
    $modal.fadeToggle 150
    false
  
  $loginModal = $ '#login-modal'
  
  $(".show-login, .close-login").on "click", (event) ->
    event.preventDefault()
    ($ "#users-modal").hide()
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)
      window.location = "/login"
    else
      loginModal.fadeToggle 150
    false

  $(".register-first-name, .register-last-name, .register-email, .register-postcode, .register-password, .register-password2").on "keypress", (event) ->
    $(".register-button").click()  if event.keyCode is 13