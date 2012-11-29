system = require '../system'

exports.index = (req,res) ->
  if res.locals.objUser.isAuthed() then res.redirect '/dashboard' else res.render 'index'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->