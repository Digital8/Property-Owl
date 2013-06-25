module.exports = ->
  ($ '.add-bookmark').click (event) ->
    event.preventDefault()
        
    if $.isAuthed

      $this = $ this
      
      $.post '/bookmarks',
        type: $this.data 'deal-type'
        id: $this.data 'deal-id'
      , (response, status, jqXHR) ->
        if jqXHR.status is 200
          
          $this.contents().last().remove()
          
          $this.append ' Saved'
          
        # else
        #   console.log status

    else
      $.showRegister()


  for bookmark in ($ '.bookmark')
    $bookmark = $ bookmark
    
    id = $bookmark.data 'bookmark-id'
    
    do (bookmark, $bookmark, id) =>
      
      $bookmark.find('.delete').click (event) ->
        event.preventDefault()
        
        if confirm('Are you sure you want to remove this?')
          $.delete "/bookmarks/#{id}", (response, status, jqXHR) ->
            
            if jqXHR.status is 200
              do $bookmark.fadeOut
            else
              alert "uh oh! spaghettio!"
              