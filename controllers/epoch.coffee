moment = require 'moment'

module.exports = (req, res) ->
  now = moment()
  epoch = moment()
  
  if req.query.test?
    console.log 'testing', req.query.test
    now = moment req.query.test
    epoch = moment req.query.test
  
  epoch.day 3
  epoch.startOf 'day'
  epoch.hours 12
  
  unless now.valueOf() < epoch.valueOf()
    epoch.add 'weeks', 1
  
  response =
    now: now.valueOf()
    epoch: epoch.valueOf()
  
  if req.query.test?
    response.debug =
      now: now.toDate()
      epoch: epoch.toDate()
  
  res.send response