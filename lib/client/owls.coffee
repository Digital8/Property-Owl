module.exports = ->
  
  header = $ '.grid-header.form-header.pane-nav'
  
  ol = $ '<ol>'
  ol.addClass 'six'
  ol.appendTo header
  
  li = $ "<li>"
  li.addClass 'active'
  li.appendTo ol
  
  activate = (section) ->
    ($ ".panes").show()
    
    ($ ".pane").hide()
    
    ($ ".#{section}.pane").show()
    
    ($ "ol li").removeClass 'active'
    
    ($ "ol li.#{section}").addClass 'active'
  
  sections = ['index', 'detail', 'address', 'area', 'image', 'file', 'deal']
  
  for section, index in sections then do (section, index) ->
    
    $pane = $ ".inputs.#{section}.pane"
    
    li = $ "<li>"
    li.appendTo ol
    
    div = $ '<div>'
    div.addClass ".ol-#{index}"
    div.appendTo li
    
    li.append section
    
    do (li) ->  
      li.click (event) ->
        event.preventDefault()
        
        activate section
  
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

  for form in ($ 'form.details-form.owl')
    $form = $ form
    
    id = $form.data 'id'
    
    approved = $form.find('[name=approved]')
    
    approved.change (event) ->
      event.preventDefault()
      
      console.log 'click'
      
      $.patch "/admin/owls/#{id}", approved: approved.is(':checked'), -> console.log arguments 
  
  