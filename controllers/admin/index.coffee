async = require 'async'

system = require '../../system'

models =
  admin: system.load.model 'admin'
  advertisement: system.load.model 'advertisement'
  properties: system.load.model 'properties'

exports.index = (req,res) ->
  models.properties.getPendingProperties (err, properties) ->
    models.properties.getPendingBarnDeals (err, projects) ->
      models.advertisement.countActive (err, results) ->
        res.render 'admin/index', activeAdvertisementCount: results, properties: properties or {}, projects: projects or {}, menu: 'dashboard'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
