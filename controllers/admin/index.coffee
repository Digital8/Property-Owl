async = require 'async'

system = require '../../system'

models =
  admin: system.load.model 'admin'
  advertisement: system.load.model 'advertisement'
  properties: system.load.model 'properties'

Owl = system.models.owl
Barn = system.models.barn

exports.index = (req,res) ->
  async.parallel
    owls: (callback) -> Owl.pending callback
    barns: (callback) -> Barn.pending callback
    activeAdvertisementCount: (callback) -> models.advertisement.countActive callback
  , (error, {owls, barns, activeAdvertisementCount}) ->
    res.render 'admin/index', activeAdvertisementCount: activeAdvertisementCount, owls: owls or {}, barns: barns or {}, menu: 'dashboard'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
