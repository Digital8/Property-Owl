browserify = require 'browserify'

module.exports = ->
  
  bundle = browserify
    debug: off
    watch: off
    cache: on
  
  bundle.addEntry "#{__dirname}/lib/client/entry.coffee"
  
  code = bundle.bundle()
  
  (req, res, next) ->
    
    if req.url is '/bundle.js'
      res.set 'Content-Type', 'text/javascript'
      res.send code
      return
    
    next? null