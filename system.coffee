fs = require 'fs'

mysql = require 'mysql'

config = require './config'

exports.acl = acl = config.acl

exports.helpers = helpers = {}

exports.models = models = {}

exports.controllers = controllers = dev: {}, admin: {}

exports.db = mysql.createConnection
  host: config.database.host
  user: config.database.user
  password: config.database.password
  database: config.database.name

exports.config = config

exports.db.prefix = config.database.prefix

exports.bucket = "#{__dirname}/public/uploads"

exports.load = load =
  model: (model) ->
    require "./models/#{model}"
  
  class: (name) ->
    require "./lib/classes/#{name}"
  
  helper: (helper) ->
    require "./lib/helpers/#{helper}"

fs.readdirSync('./models').forEach (module) ->
  return if module[0] is '.'
  console.log "✓ [model] #{module}"
  models[module.split('.')[0]] = require "./models/#{module}"

fs.readdirSync('./controllers').forEach (module) ->
  return if module[0] is '.'
  return if (fs.statSync "./controllers/#{module}").isDirectory()
  console.log "✓ [controller] #{module}"
  controllers[module.split('.')[0]] = require "./controllers/#{module}"

fs.readdirSync('./controllers/admin').forEach (module) ->
  return if module[0] is '.'
  console.log "✓ [controller/admin] #{module}"
  controllers.admin[module.split('.')[0]] = require "./controllers/admin/#{module}"

fs.readdirSync('./controllers/dev').forEach (module) ->
  return if module[0] is '.'
  console.log "✓ [controller/dev] #{module}"
  controllers.dev[module.split('.')[0]] = require "./controllers/dev/#{module}"

fs.readdirSync('./lib/helpers').forEach (module) ->
  return if module[0] is '.'
  console.log "✓ [helpers] #{module}"
  helpers[module.split('.')[0]] = require "./lib/helpers/#{module}"