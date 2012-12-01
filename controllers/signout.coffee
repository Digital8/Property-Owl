system = require '../system'

models = user: system.load.model 'user'

exports.index = (req,res) ->
  delete req.session.user_id
  
  res.redirect '/'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->