###
 * Developer Properties Controller
 *
 * Controller For adding/editing properties
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models =
  properties: system.load.model('properties')

helpers = {}
 
exports.index = (req,res) ->
  models.properties.getPropertyByUserId res.locals.objUser.id, (err, properties) ->
    if err then throw err
    console.log properties
    res.render 'developers/properties/index', properties: properties
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->
  models.properties.getPropertyTypes (err, results) ->
    res.render 'developers/properties/add', p_types: results

exports.create = (req,res) ->
  req.flash('info','do da foo')
  req.body.user_id = res.locals.objUser.id
  models.properties.addProperty req.body, (err, results) ->
    if err then throw err
    res.redirect 'back'

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->