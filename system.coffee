###
 * System
 *
 * Core component to application.
 * The general go-to file to load in resources required
 *
 * @package		Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

config = require './config'
mysql = require 'mysql'
fs = require 'fs'

exports.db = mysql.createConnection
  host     : config.database.host
  user     : config.database.user
  password : config.database.password
  database : config.database.name

exports.config = config

exports.db.prefix = config.database.prefix

exports.bucket = "#{__dirname}/uploads"

# Give our loader some methods to load in specific resources
exports.load = 
  model: (model) ->
    require './models/' + model
  
  class: (className) ->
    require './lib/classes/' + className
	
  helper: (helper) ->
    require './lib/helpers/' + helper