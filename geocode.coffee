request = require 'request'

geoURL = (q, sensor = no) ->
  "http://maps.googleapis.com/maps/api/geocode/json?address=#{q}&sensor=#{sensor}"

module.exports = (app) ->
  app.post '/geocode', (req, res) ->
    request (geoURL req.body.query), (error, response, body) ->
      
      res.send body