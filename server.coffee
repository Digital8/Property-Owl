https = require 'https'
http = require 'http'
fs = require 'fs'

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
  
bundle = (require './browserifyafication.coffee') app
 
app.configure ->
  console.start 'configure'
  
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use expressValidator
  app.use express.cookieParser 'secretsnake'
  app.use express.session 'monkeyjuice'
  app.use flashify
  app.use bundle
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
    system.db.query "SELECT COUNT(*) AS count FROM po_users WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)", (error, rows) ->
      return done() unless rows?.length
      app.locals.signupsThisMonth = rows.pop().count
      done()
  
  app.use (req, res, done) ->
    DevelopmentType = system.models.development_type
    
    DevelopmentType.all (error, developmentTypes) ->
      system.data ?= {}
      system.data.developmentTypes = developmentTypes
      done()
  
  app.use (req, res, done) ->
    DealType = system.models.deal_type
    
    DealType.all (error, dealTypes) ->
      system.data ?= {}
      system.data.dealTypes = dealTypes
      done()
  
  app.use (req, res, done) ->
    res.locals.session  = req.session
    res.locals.globals  = config.globals
    res.locals.modules  = config.modules ? {} # If modules exist, allow views to check its status
    res.locals.objUser  = new classes.user [] # Empty user object
    res.locals.req      = req
    res.locals.menu     = {}
    res.locals.data     = system.data
    res.locals._s       = require 'underscore.string'
    res.locals.moment = require 'moment'
    
    if app.argv.hack then req.session.user_id = 1
    
    res.locals.navigation = [
      {key: 'aus-best-deal',    href: '/owls/top',        label: "Australia's Best Deal"}
      {key: 'best-state-deal',  href: '/owls/state/qld',  label: 'Best State Deal'}
      {key: 'owl-deals',        href: '#',                label: 'Owl Deals'}
      {key: 'wise-owl',         href: '#',                label: 'Wise Owl'}
      {key: 'products',         href: '#',                label: 'Products & Services'}
      {key: 'my-nest',          href: '#',                label: 'My Nest'}
    ]
    
    url = '/' + req.url.split('/')[1] + '%'
    if url is '/%' then url = '/'
    
    console.log url.green
    
    console.start 'ads'
    
    async.parallel
      top       : (callback) -> models.advertisement.random url, 'top',         (err, result) -> callback err, result
      upperTower: (callback) -> models.advertisement.random url, 'upper tower', (err, result) -> callback err, result
      lowerTower: (callback) -> models.advertisement.random url, 'lower tower', (err, result) -> callback err, result
      upperBox  : (callback) -> models.advertisement.random url, 'upper box',   (err, result) -> callback err, result
      lowerBox  : (callback) -> models.advertisement.random url, 'lower box',   (err, result) -> callback err, result
    , (err, results) ->
      res.locals.adspaceTop   = if results.top?         then results.top        else ''
      res.locals.adUpperTower = if results.upperTower?  then results.upperTower else ''
      res.locals.adLowerTower = if results.lowerTower?  then results.lowerTower else ''
      res.locals.adUpperBox   = if results.upperBox?    then results.upperBox   else ''
      res.locals.adLowerBox   = if results.lowerBox?    then results.lowerBox   else ''
      
      console.stop 'ads'
      do done
  
  app.use (req, res, done) ->
    if req.session.user_id? or req.cookies.pouser?
      user_id = req.session.user_id or req.cookies.pouser
      
      models.user.getUserById user_id, (err, results) ->
        if err then throw err
        
        if results.length > 0
          results =  results.pop();
          
          if req.cookies.pouser?
            if results.password == req.cookies.popwd
              req.session.user_id = user_id
              res.locals.objUser = new classes.user results
            else
              # GO AWAY HAX0R
              delete req.session.user_id
              res.clearCookie 'pouser'
              res.clearCookie 'popwd'
              res.redirect '/'
          else
            res.locals.objUser = new classes.user results
          
        do done
    
    else
      do done
  
  app.use app.router
  
  console.stop 'configure'

(require './import') app, system

(require './geocode') app

(require './routes') app

server = https.createServer
  key: fs.readFileSync(config.ssl.key)
  cert: fs.readFileSync(config.ssl.cert)
  passphrase: config.passphrase
, app

server.listen config.https.port, ->
  console.log "Server started on port #{config.port}"
  
  console.stop 'boot'
  
  console.report()

insecureApp = express()

insecureApp.get '*', (req, res) ->
  console.log req
  res.redirect "https://#{req.headers.host}#{req.url}"

insecureServer = http.createServer insecureApp
insecureServer.listen config.http.port