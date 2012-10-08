###
 * Skeleton Controller
 *
 * Controller Template
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models =  
  properties: system.load.model 'properties'

helpers = {}
 
exports.index = (req,res) ->
  
exports.view = (req,res) ->
  models.properties.getAllPropertiesById req.params.id, (err, results) ->
    console.log results
    if err then console.log err
    if results.length is 0
      res.render 'properties/not_found'
    else
      res.render 'properties/view', property: results.pop()
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->