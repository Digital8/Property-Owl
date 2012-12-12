moment = require 'moment'

module.exports = ->
  fetch = (callback) ->
    $.get '/epoch', ({now, epoch}) ->
      interval = moment.duration (epoch - now)
      
      callback
        days: interval.days()
        hours: interval.hours()
        minutes: interval.minutes()
  
  update = ->
    fetch ({days, hours, minutes}) ->
      ($ '#day-timer-days').text days
      ($ '#day-timer-hours').text hours
      ($ '#day-timer-mins').text minutes
      
      for timer in ($ '.time')
        ($ timer).text "#{days}:#{hours}:#{minutes}"
  
  # initial update
  do update
  
  # wait until next minute, then update every minute after
  link = ->
    setInterval update, 1000 * 60
  
  setTimeout link, (60 - (new Date).getSeconds()) * 1000