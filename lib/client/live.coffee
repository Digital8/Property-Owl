module.exports = ->
  random = (min, max) ->
    range = max - min
    return (Math.floor (Math.random() * range)) + min
  
  increment = ->
    value = ($ '.home-counter .value').text()
    number = Number value
    next = number += random 0, 3
    
    ($ '.home-counter .value').text next
    
    setTimeout increment, (random 5, 10) * 1000
  
  setTimeout increment, (random 5, 10) * 1000