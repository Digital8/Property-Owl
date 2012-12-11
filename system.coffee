config = require './config'

exports.acl = acl = config.acl

exports.helpers = helpers = {}

exports.models = models = {}

exports.controllers = controllers = dev: {}, admin: {}

exports.config = config

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