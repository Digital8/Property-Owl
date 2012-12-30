module.exports = ->
  
  header = $ '.grid-header.form-header.pane-nav'
  
  ol = $ '<ol>'
  ol.addClass 'six'
  ol.appendTo header
  
  #li = $ "<li>"
  #li.addClass 'active'
  #li.appendTo ol
  
  activate = (section) ->
    ($ ".panes").show()
    
    ($ ".pane").hide()
    
    ($ ".#{section}.pane").show()
    
    ol.find('li').removeClass 'active'
    
    ol.find("li.#{section}").addClass 'active'
    
    window.location.hash = section
  
  sections =
    index: {title: 'approval'}
    detail: {}
    address: {}
    area: {}
    image: {}
    file: {}
    deal: {}
  
  i = 0
  for key, section of sections
    section.title ?= key
    section.index = i
    section.key = key
    i++
  
  for key, section of sections then do (key, section) ->
    
    $pane = $ ".inputs.#{key}.pane"
    
    li = $ "<li>"
    li.css 'width', '14%'
    li.addClass key
    li.appendTo ol
    
    div = $ '<div>'
    div.addClass ".ol-#{section.index}"
    div.appendTo li
    
    li.append section.title
    
    do (li) ->
      li.click (event) ->
        event.preventDefault()
        
        activate key
  
  if window.location.hash? and window.location.hash.length
    activate window.location.hash[1..]
  else
    activate 'index'
  
  #   # $panes = $ '.panes'
    
  #   class Pane
  #     constructor: ({@element}) ->
    
  #   class Panes
  #     constructor: ({@element}) ->
    
  #   $panes.data 'init', ->
  #     $panes.data 'panes', []
      
  #     header = $ '.grid-header.form-header'
      
  #     header.empty()
      
  #     ol = $ '<ol>'
  #     ol.appendTo header
      
  #     panes = new Panes
          
  #     # panes = (new Pane element: element) for element in $ '.inputs.pane'
    
  #   # change = ->
  #   #   deals = $ '.deals .deal'
      
  #   #   # for deal in deals
    
  #   # change()
  
  ###
  
  $.delete "/admin/barns/#{barnId}/owls/#{owlId}", ->
          console.log arguments
          
          $row.remove()
  ###

  for form in ($ 'form.details-form.owl')
    $form = $ form
    
    id = $form.data 'id'
    
    approved = $form.find('[name=approved]')
    
    approved.change (event) ->
      event.preventDefault()
      
      console.log 'click'
      
      $.patch "/admin/owls/#{id}", approved: approved.is(':checked'), -> console.log arguments 
  
  