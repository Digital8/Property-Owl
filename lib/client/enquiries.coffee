module.exports = ->
  
  $modal = $ '#enquiry-modal'
  
  $form = $modal.find 'form'
  
  $form.on 'submit', (event) ->
    event.preventDefault()
    (require './ajax')
      url: '/enquiries'
      form: $form
      success: (data, textStatus, jqXHR) ->
        (require './modals').fill
          modal: $modal
          title: "Thanks!"
          html: """<p>Enquiry sent.</p>"""