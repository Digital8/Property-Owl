###
middleware for browserify
- since substack decided to take it out
###

CoffeeScript = require 'coffee-script'

browserify = require 'browserify'

module.exports = (app) ->
  bundle = browserify
    debug: on
    watch: on
    cache: off
  
  bundle.addEntry "#{__dirname}/lib/client/entry.coffee"
  
  app.get '/bundle.js', (req, res) ->
    res.send bundle.bundle()