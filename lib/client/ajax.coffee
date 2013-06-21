module.exports = ({url, form, success, error}) ->
  
  $form = form
  
  $.ajax
    url: url
    type: 'POST'
    data: (require './serialize') $form
    dataType: 'json'
    accepts: {json: 'application/json'}
    success: success
    error: (jqXHR, textStatus, errorThrown) ->
      
      {status} = jqXHR
      
      {message, errors} = $.parseJSON jqXHR.responseText
      
      $("#generic-modal, #generic-modal .modal.main").removeClass 'success'
      $form.css
        color: 'white'
        'text-align': 'center'
      
      $title = $ '#generic-modal-title'
      $title.text message
      
      $content = $ '#generic-modal-content'
      $content.empty()
      
      if status is 409
        
        $content.text 'You already registered.'
      
      if status is 422
        
        $title.text 'Please resolve the following:'
        
        $ul = $ '<ul>'
        $ul.appendTo $content
        
        for error in errors
          $ul.append $ "<li><b>#{error.param} is #{error.msg}</b></li>"
      
      if status is 500
        
        $content.text 'Please try again later.'
      
      $("#generic-modal").fadeIn()