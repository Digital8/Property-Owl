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
  deals: system.load.model('deals')

helpers = {}
 
exports.index = (req,res) ->
  models.deals.getDealsByUserId res.locals.objUser.id, (err, results) ->
    if err then throw err
    res.render 'developers/deals/index', deals: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->
  models.properties.getPropertyByUserId res.locals.objUser.id , (err, properties) ->
    res.render 'developers/deals/add', properties: properties or {}

exports.create = (req,res) ->
  res.send req.body

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->