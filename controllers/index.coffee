system = require '../system'

exports.index = (req,res) ->
  Owl = system.models.owl
  
  Owl.top (error, owl) ->
    res.render 'index', owl: owl

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->