require 'colors'

hack = require './hack'
hack.augmentConsole()

console.start 'boot'

async = require 'async'
express = require 'express'
expressValidator = require 'express-validator'
flashify = require 'flashify'

{load, config} = system = require './system'

models =
  user: load.model 'user'
  advertisement: load.model 'advertisement'

classes = user: load.class 'user'

app = express()

hack.augmentApp app
hack.augmentDB app, system

app.configure ->
  console.start 'configure'
  
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  
  #app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use expressValidator
  app.use express.cookieParser 'secretsnake'
  app.use express.session 'monkeyjuice'
  app.use flashify
  app.use express.static "#{__dirname}/public"
  
  app.use (req, res, done) ->
    schemas = []
    for key, model of system.models when model instanceof Function
      schemas.push model
    
    async.forEach schemas, (schema, callback) ->
      system.db.query "SHOW COLUMNS FROM #{schema.table.name}", (error, rows) ->
        for field in rows
          schema.table.columns[field.Field] = field
        callback()
    , (error) -> done()
  
  app.use (req, res, done) ->
    DevelopmentType = system.models.development_type
    
    DevelopmentType.all (error, developmentTypes) ->
      system.data ?= {}
      system.data.developmentTypes = developmentTypes
      done()
  
  app.use (req, res, done) ->
    res.locals.session  = req.session
    res.locals.globals = config.globals
    res.locals.modules = config.modules ? {} # If modules exist, allow views to check its status
    res.locals.objUser = new classes.user [] # Empty user object
    res.locals.req = req
    res.locals.menu = {}
    res.locals.data = system.data
    
    if app.argv.hack
      req.session.user_id = 1
    
    res.locals.navigation = [
      {key: 'aus-best-deal', href: '/owls/top', label: "Australia's Best Deal"}
      {key: 'best-state-deal', href: '/owls/state/qld', label: 'Best State Deal'}
      {key: 'owl-deals', href: '#', label: 'Owl Deals'}
      {key: 'wise-owl', href: '#', label: 'Wise Owl'}
      {key: 'products', href: '#', label: 'Products & Services'}
      {key: 'my-nest', href: '#', label: 'My Nest'}
    ]
    
    url = '/' + req.url.split('/')[1] + '%'
    if url is '/%' then url = '/'
    
    console.log url.green
    
    console.start 'ads'
    
    adsLoaded = ->
      console.stop 'ads'
      done()
    
    models.advertisement.random url, 'top', (err, adspaceTop) ->
      models.advertisement.random url, 'upper tower', (err, adUpperTower) ->
        models.advertisement.random url, 'lower tower', (err, adLowerTower) ->
          models.advertisement.random url, 'upper box', (err, adUpperBox) ->
            models.advertisement.random url, 'lower box', (err, adLowerBox) ->
            res.locals.adspaceTop = if adspaceTop? then adspaceTop else ''
            res.locals.adUpperTower = if adUpperTower? then adUpperTower else ''
            res.locals.adLowerTower = if adLowerTower? then adLowerTower else ''
            res.locals.adUpperBox = if adUpperBox? then adUpperBox else ''
            res.locals.adLowerBox  = if adLowerBox? then adLowerBox else ''
            
            if req.session.user_id? or req.cookies.pouser?
              user_id = req.session.user_id or req.cookies.pouser
              models.user.getUserById user_id, (err, results) ->
                if err then throw err
                
                if results.length > 0
                  res.locals.objUser = new classes.user results.pop()
                  
                adsLoaded()
            
            else
              adsLoaded()
  
  app.use app.router
  
  console.stop 'configure'

server = app.listen config.port

(require './import') app, system

(require './browserifyafication.coffee') app

(require './geocode') app

(require './routes') app

console.log "Server started on port #{config.port}"

console.stop 'boot'

console.report()
