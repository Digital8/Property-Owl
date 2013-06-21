module.exports = ->
  
  $modal = $ '.secure-deal-overlay'
  
  $form = $modal.find 'form'
  
  $form.on 'submit', (event) ->
    event.preventDefault()
    (require './ajax')
      url: '/registrations'
      form: $form
      success: (data, textStatus, jqXHR) ->
        
        (require './modals').fill
          modal: $modal
          title: "Thanks for your interest!"
          html: """
            <p>There has been a large amount of interest on this property.</p>
            <p>We have forwarded your registered interest to the seller who will advise whether you have been successful in swooping in on the deal.</p>
            <p>In the meantime, feel free to enquire about any other great deal.</p>
          """
  
  do ->
    $(".reg-delete").click (e) ->
      e.preventDefault()
      id = $(this).data("id")
      $that = $(this)
      if confirm("Are you sure you want to remove this?")
        $.delete "/registrations/#{id}", (body, textStatus, jqXHR) ->
          if jqXHR.status is 200
            $that.parent().parent().fadeOut()
  
  do ->
    $(".secure-deal-first-name, .secure-deal-last-name, .secure-deal-email, .secure-deal-phone, .secure-deal-comment").on "keypress", (event) ->
      if event.keyCode is 13
        $(".secure-deal-button").click()