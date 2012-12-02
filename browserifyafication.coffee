CoffeeScript = require 'coffee-script'

browserify = require 'browserify'

module.exports = (app) ->
  bundle = browserify
    debug: on
    watch: on
    cache: on
  
  bundle.addEntry "#{__dirname}/lib/client/entry.coffee"
  
  app.get '/bundle.js', (req, res) ->
    res.send bundle.bundle()