###
 * Index Controller
 *
 * Controller for homepage of website
 *
 * @package   Time for Advice
 * @author    Brendan Scarvell <bscarvell@gmail.com>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

# GET
exports.index = (req,res) ->
  if res.locals.objUser.isAuthed() then res.redirect '/dashboard' else res.render 'index'

# GET    
exports.view = (req,res) ->

# GET
exports.add = (req,res) ->

# PUT
exports.create = (req,res) ->

# GET
exports.edit = (req,res) ->

# POST
exports.update = (req,res) ->

# DEL
exports.destroy = (req,res) ->

