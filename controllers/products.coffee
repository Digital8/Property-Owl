system = require '../system'

helpers = hash: system.load.helper 'hash'
  
models = services: system.load.model 'services'

exports.index = (req,res) ->
  models.services.getAllServices (err, results) ->
    if err then throw err
    res.render 'products', menu: 'products', services: results or {}

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->