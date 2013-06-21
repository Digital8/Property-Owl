module.exports = ->
  
  secureDealModal = $(".secure-deal-overlay")
  
  $form = $('form.modal-content.details-form')
  
  $(".show-secure-deal, .close-secure-deal").on "click", (event) ->
    event.preventDefault()
    secureDealModal.hide 150
    false
  
  $(".show-secure-deal").on "click", (event) ->
    
    event.preventDefault()
    
    unless $.isAuthed
      return $.showRegister()
    
    $this = $ this
    ($form.find 'input[name=entity_id]').val $this.data 'entity_id'
    ($form.find 'input[name=entity_type]').val $this.data 'entity_type'
    
    secureDealModal.fadeIn 150
    
    false
  
  $(".secure-deal-button").on 'click', ->
    $form.submit()
  
  $form.on 'submit', (event) ->
    
    event.preventDefault()
    
    inputs = $form.serializeArray()
    
    body = {}
    for input in inputs
      body[input.name] = input.value
    
    $.ajax
    
      url: '/registrations'
      type: 'POST'
      data: body
      dataType: 'json'
      accepts:
        json: 'application/json'
      
      success: (data, textStatus, jqXHR) ->
        
        secureDealModal.find('*').removeClass 'success'
        
        secureDealModal.find('.modal-title').text "Thanks for your interest!"
        
        hidden = $form.find('*').hide()
        
        $form.css
          color: 'white'
          'text-align': 'center'
        
        $form.html """
        <p>There has been a large amount of interest on this property.</p>
        <p>We have forwarded your registered interest to the seller who will advise whether you have been successful in swooping in on the deal.</p>
        <p>In the meantime, feel free to enquire about any other great deal.</p>
        """
      
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
  
  do ->
    $(".reg-delete").click (e) ->
      e.preventDefault()
      id = $(this).data("id")
      $that = $(this)
      if confirm("Are you sure you want to remove this?")
        $.delete "/registrations/#{id}", (body, textStatus, jqXHR) ->
          if jqXHR.status is 200
            $that.parent().parent().fadeOut()