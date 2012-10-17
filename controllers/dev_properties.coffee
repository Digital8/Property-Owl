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
  res.render 'developers/properties/index'
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->
  models.properties.getPropertyTypes (err, results) ->
    res.render 'developers/properties/add', p_types: results

exports.create = (req,res) ->
  req.flash('info','do da foo')
  console.log req.body
  res.redirect 'back'

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->