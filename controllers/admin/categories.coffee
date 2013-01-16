async = require 'async'

system = require '../../system'

models =
  advertisement: system.load.model 'advertisement'
  users: system.load.model 'user'

Owl = system.models.owl
Barn = system.models.barn
Affiliate = system.models.affiliate

exports.index = (req,res) ->

exports.view = (req,res) ->

exports.add = (req,res) ->
  res.render 'admin/categories/add'

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->
