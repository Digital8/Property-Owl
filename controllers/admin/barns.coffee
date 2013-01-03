fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

system = require '../../system'

Barn = system.models.barn
User = system.models.user

exports.index = (req, res) ->
  Barn.all (error, barns) ->
      res.render 'admin/barns/index', barns: barns

exports.edit = (req, res) ->
  Barn.get req.params.id, (error, barn) ->
    User.getUsersByGroup 2, (error, developers) ->
      console.log 'got', arguments
    
      res.render 'admin/barns/edit', barn: barn, developers: developers

exports.add = (req, res) ->
  Barn.new (error, barn) ->
    User.getUsersByGroup 2, (error, developers) ->
      res.render 'admin/barns/add', barn: barn, developers: developers

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

exports.update = (req, res) ->
  Barn.update req.params.id, req.body, (error, barn) ->
    
    barn.upload req, ->
      res.redirect '/admin/barns'

exports.patch = (req, res) ->
  res.send status: 200