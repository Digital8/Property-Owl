module.exports = modals = ->
  
  for overlay in $ '.overlay'
    
    $overlay = $ overlay
    
    $modal = $overlay.find '.modal'
    
    $modal.css
      padding: '168px 55px 0'
    
    $close = $modal.find '.close'
    
    $submit = $modal.find 'input[type=submit]'
    
    $form = $modal.find 'form'
    
    do ($modal, $overlay, $close, $submit, $form) ->
    
      $close.on 'click', (event) ->
        
        event.preventDefault()
        
        $overlay.fadeOut 150
      
      $submit.on 'click', (event) ->
        event.preventDefault()
        $form.submit()
  
  for button in $ '[data-modal]'
    $button = $ button
    do ($button) ->
      $button.on 'click', (event) ->
        event.preventDefault()
        
        unless $.isAuthed
          return $.showRegister()
        
        $modal = $ "##{$button.data 'modal'}-modal"
        
        $form = $modal.find 'form'
        
        ($form.find 'input[name=entity_id]').val $button.data 'entity_id'
        ($form.find 'input[name=entity_type]').val $button.data 'entity_type'
        
        $modal.fadeIn()

modals.fill = ({modal, title, html}) ->
  
  $modal = $ modal
  $form = $modal.find 'form'
  
  $modal.find('*').removeClass 'success'
  
  $modal.find('.modal-title').text title
  
  hidden = $form.find('*').hide()
  
  $form.css
    color: 'white'
    'text-align': 'center'
  
  $form.html html