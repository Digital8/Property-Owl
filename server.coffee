fs = require 'fs'
https = require 'https'
http = require 'http'
util = require 'util'

require 'colors'

hack = require './hack'
hack.augmentConsole()

console.start 'boot'

async = require 'async'
express = require 'express'
expressValidator = require 'express-validator'
flashify = require 'flashify'
moment = require 'moment'
mysql = require 'mysql'
optimist = require 'optimist'
prettyjson = require 'prettyjson'

argv = optimist
  .alias('verbose', 'v')
  .alias('fake', 'f')
  .alias('time', 't')
  .argv

db = null

Model = require './lib/model'

{models, controllers} = (require './import') argv

app = express()

app.argv = argv

hack.augmentApp app

config = require './config'

app.configure ->
  async.series
    db: (callback) ->
      db = mysql.createConnection
        host: config.database.host
        user: config.database.user
        password: config.database.password
        database: config.database.name
        # debug: on
      
      hack.augmentDB app, db
      
      db.connect callback
  
  , (error) ->
    
    if error? then console.log error ; process.exit()
    
    console.start 'configure'
    
    # app.enable 'trust proxy'
    
    app.set 'views', "#{__dirname}/views"
    app.set 'view engine', 'jade'
    
    app.use express.static "#{__dirname}/public", maxAge: 1024
    app.use express.logger 'dev'
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use expressValidator
    app.use express.cookieParser 'secretsnake'
    app.use express.session 'monkeyjuice'
    app.use flashify
    app.use do require './browserify.coffee'
    
    (require './lib/schema') {models, db, controllers}
    
    app.use (require './lib/epoch') app
    
    app.use (req, res, next) ->
      res.locals.session  = req.session
      res.locals.globals  = config.globals
      res.locals.modules  = config.modules ? {} # If modules exist, allow views to check its status
      res.locals.req      = req
      res.locals.menu     = {}
      res.locals._s       = require 'underscore.string'
      res.locals.moment = require 'moment'
      res.locals.util = require 'util'
      res.locals._ = require 'underscore'
      res.locals.date_input = (date) -> (moment date)?.format 'YYYY-MM-DD'
      
      if app.argv.hack then req.session.user_id = config.hack?.user?.id or 1
      
      next? null
    
    app.use do require './lib/nav'
    
    app.use do require './lib/ads'
    
    app.use do require './lib/auth'
    
    # ?sort= middleware
    app.use (req, res, next) ->
      res.locals.sort = req.query.sort or null
      do next
    
    app.use app.router
    
    console.stop 'configure'
    
    (require './geocode') app
    
    (require './routes') {app, controllers}
    
    async.parallel
      
      https: (callback) ->
        
        server = https.createServer
          key: fs.readFileSync config.ssl.key
          cert: fs.readFileSync config.ssl.cert
          passphrase: config.ssl.passphrase
        , app
        
        server.listen config.https.port, ->
          
          console.log "https://localhost:#{config.https.port}"
          
          console.stop 'boot'
          
          console.report()
          
          callback null
      
      http: (callback) ->
        
        insecureApp = express()
        insecureApp.use express.static "#{__dirname}/public", maxAge: 1024
        
        insecureApp.get '*', (req, res) ->
          res.redirect "http://propertyowlnest.com/"
          #res.redirect "https://#{req.headers.host.split(':')[0]}#{req.url}"
        
        insecureServer = http.createServer insecureApp
        insecureServer.listen config.http.port, ->
          console.log "http://localhost:#{config.http.port}"
          callback null
    
    , (error) ->
      
      do require './banner'