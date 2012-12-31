###
middleware for browserify
- since substack decided to take it out
###

CoffeeScript = require 'coffee-script'

browserify = require 'browserify'

module.exports = ->
  bundle = browserify
    debug: on
    watch: on
    cache: off
  
  bundle.addEntry "#{__dirname}/lib/client/entry.coffee"
  
  return (req, res, next) ->
    if req.url is '/bundle.js'
      res.set 'Content-Type', 'text/javascript'
      res.send bundle.bundle()
    else
      next()