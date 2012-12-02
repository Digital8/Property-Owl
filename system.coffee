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

exports.Model = require './lib/model'
exports.Table = require './lib/table'