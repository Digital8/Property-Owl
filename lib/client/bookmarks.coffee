module.exports = ->
  ($ '.add-bookmark').click (event) ->
    event.preventDefault()
    
    $this = $ this
    
    $.post '/bookmarks',
      type: $this.data 'deal-type'
      id: $this.data 'deal-id'
    , (response, status) ->
      if response.status is 200
        
        $this.contents().last().remove()
        
        $this.append ' Saved'
        
      else
        alert status

  for bookmark in ($ '.bookmark')
    $bookmark = $ bookmark
    
    id = $bookmark.data 'bookmark-id'
    
    do (bookmark, $bookmark, id) =>
      
      $bookmark.find('.delete').click (event) ->
        event.preventDefault()
        
        $.delete "/bookmarks/#{id}", (response, status, jqXHR) ->
          
          if jqXHR.status is 200
            do $bookmark.remove
          else
            alert "uh oh! spaghettio!"