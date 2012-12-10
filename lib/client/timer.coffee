moment = require 'moment'

module.exports = ->
  now = Date.now()
  
  $.get '/ajax/epoch', (timestamp) ->
    epoch = moment timestamp
    
    console.log epoch
    
    console.log epoch.duration.days()
    
    # delta =
    #   days: epoch.diff now, 'days'
    #   hours: epoch.diff now, 'hours'
    #   minutes: epoch.diff now, 'minutes'
    
    # console.log delta