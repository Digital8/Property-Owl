($ '.bookmark').click (event) ->
  event.preventDefault()
  
  $this = $ this
  
  $.post '/ajax/bookmark',
    type: $this.data 'deal-type'
    id: $this.data 'deal-id'
  , (response, status) ->
    if response.status is 200
      alert 'saved'
    else
      alert status