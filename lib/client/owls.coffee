module.exports = ->
  
  header = $ '.grid-header.form-header.pane-nav'
  
  ol = $ '<ol>'
  ol.addClass 'six'
  ol.appendTo header
  
  activate = (section) ->
    ($ ".panes").show()
    
    ($ ".pane").hide()
    
    ($ ".#{section}.pane").show()
    
    ol.find('li').removeClass 'active'
    
    ol.find("li.#{section}").addClass 'active'
    
    window.location.hash = section
  
  sections = {}
  
  for pane in $ '.inputs.pane'
    
    $pane = $ pane
    
    key = $pane.data 'key'
    
    label = $pane.data 'label'
    
    sections[key] = pane: $pane, key: key, label: label
  
  i = 0
  for key, section of sections
    section.title = section.label or section.key
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
    level = $('.panes').data('tab')
    if level is 3
      activate 'index'
    else 
      activate 'detail'
  
  for form in $ 'form.details-form.owl'
    
    $form = $ form
    
    id = $form.data 'id'
    
    # approved bool
    
    approved = $form.find '[name=approved]'
    
    approved.change (event) ->
      event.preventDefault()
      
      $.patch "/admin/owls/#{id}",
        approved: approved.is ':checked'
      , ->
        
    # date
    
    picker = $ '#approved_at_val'
    
    picker.change (event) ->
      
      $.patch "/admin/owls/#{id}",
        approved_at: picker.val()
      , (body, res, xhr) ->