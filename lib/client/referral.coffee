module.exports = ->
  
  $modal = $ '.refer-friend-overlay'
  
  $form = $modal.find 'form'
  
  $form.on 'submit', (event) ->
    event.preventDefault()
    (require './ajax')
      url: '/referrals'
      form: $form
      success: (data, textStatus, jqXHR) ->
        (require './modals').fill
          modal: $modal
          title: "Thanks!"
          html: """<p>You have successfully referred your friend.</p>"""
  
  $(".refer-friend-first-name, .refer-friend-last-name, .refer-friend-email, .refer-friend-phone, .refer-friend-comment").on "keypress", (event) ->
    $(".refer-friend-button").click()  if event.keyCode is 13