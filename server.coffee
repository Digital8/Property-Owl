###
 * Server
 *
 * Application Server
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
 
express = require 'express'
expressValidator = require 'express-validator'
flashify = require 'flashify'

# Include system core
system = require './system'

# Load some helpers
helpers = {}

# Load global models
models =
  user: system.load.model 'user'
  advertisement: system.load.model 'advertisement'

classes = 
  user: system.load.class 'user'

app = express()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use expressValidator
  app.use express.cookieParser('secretsecret')
  app.use express.session()
  app.use flashify
  app.use express.static "#{__dirname}/public"
  app.use (req,res,done) ->
    res.locals.session  = req.session
    res.locals.globals = system.config.globals
    res.locals.modules = system.config.modules ? {} # If modules exist, allow views to check its status
    res.locals.objUser = new classes.user [] # Empty user object
    res.locals.menu = {}
    res.locals.navigation = [
      {key: 'aus-best-deal', href: '/best-deal', label: 'Australia\'s Best Deal'}
      {key: 'best-state-deal', href: '/deals/state/qld', label: 'Best State Deal'}
      {key: 'owl-deals', href: '#', label: 'Owl Deals'}
      {key: 'wise-owl', href: '#', label: 'Wise Owl'}
      {key: 'products', href: '#', label: 'Products & Services'}
      {key: 'my-nest', href: '#', label: 'My Nest'}
    ]
    
    models.advertisement.random (err, ad) ->
      res.locals.ad = ad.image_id
      
      if req.session.user_id?
        models.user.getUserById req.session.user_id, (err, results) ->
          if err then throw err
          if results.length > 0
            res.locals.objUser = new classes.user results.pop()
            done()
      else
        done()
  
  app.use app.router
  
server = app.listen system.config.port


# Application routes
require('./routes')(app)

console.log "Server started on port #{system.config.port}"

