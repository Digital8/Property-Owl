fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

Barn = system.models.barn

exports.index = (req, res) ->
  Barn.all (error, barns) ->
    res.render 'admin/barns/index', barns: barns

exports.edit = (req, res) ->
  Barn.get req.params.id, (error, owl) ->
    res.render 'admin/barns/edit', barn: barn

exports.add = (req, res) ->
  Barn.new (error, barn) ->
    res.render 'admin/barns/add', barn: barn

exports.create = (req, res) ->
  console.log 'creating barn'
  Barn.create req.body, (error, barn) ->
    # barn.upload req, ->
    res.redirect "/barns/#{barn.id}"

exports.delete = (req, res) ->
  Barn.get req.params.id, (error, barn) ->
    res.render 'admin/barns/delete', barn: barn

exports.destroy = (req, res) ->
  Barn.delete req.params.id, (error) ->
    req.flash 'success', 'barn deleted'
    
    res.redirect '/admin/barns'

# system = require '../../system'

# Barn = system.models.barn

# exports.index = (req, res) ->
#   Barn.all (error, barns) ->
#     res.render 'admin/barns/index', barns: barns

# exports.add = (req, res) ->
#   res.render 'admin/barns/add'