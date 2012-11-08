###
 * Admin Pages Controller
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models = 
  services: system.load.model('services')

helpers = {}
 
exports.index = (req, res) ->
  models.services.getAllServices (err, results) ->
    res.render 'administration/services/index', services: results or {}
  
exports.view = (req, res) ->
  
exports.add = (req,res) ->
  res.render 'administration/services/add'
  
exports.create = (req, res) ->
          
exports.edit = (req, res) ->
  
exports.update = (req, res) ->
  
exports.destroy = (req,  res) ->