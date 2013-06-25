moment = require 'moment'

module.exports = (app) ->
  
  (req, res, done) ->
    
    if app.argv.time?
      now = moment app.argv.time
      epoch = moment app.argv.time
    else
      now = moment()
      epoch = moment()
    
    epoch.day 3
    epoch.startOf 'day'
    epoch.hours 12
    
    unless now.valueOf() > epoch.valueOf()
      epoch.subtract 'weeks', 1
    
    done? null