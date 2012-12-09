async = require 'async'

system = require '../../system'

models =
  admin: system.load.model 'admin'
  advertisement: system.load.model 'advertisement'
  properties: system.load.model 'properties'

Owl = system.models.owl
Barn = system.models.barn

exports.index = (req,res) ->
  Owl.pendingowls (error, owls) ->
    Barn.pendingbarns (error, barns) ->
      models.advertisement.countActive (err, results) ->
        res.render 'admin/index', activeAdvertisementCount: results, owls: owls or {}, barns: barns or {}, menu: 'dashboard'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
