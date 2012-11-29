fs = require 'fs'

mysql = require 'mysql'

config = require './config'

exports.acl = config.acl

exports.controllers = {}

exports.db = mysql.createConnection
  host: config.database.host
  user: config.database.user
  password: config.database.password
  database: config.database.name

exports.config = config

exports.db.prefix = config.database.prefix

exports.bucket = "#{__dirname}/public/uploads"

# Give our loader some methods to load in specific resources
exports.load = 
  model: (model) ->
    require './models/' + model
  
  class: (className) ->
    require './lib/classes/' + className
	
  helper: (helper) ->
    require './lib/helpers/' + helper