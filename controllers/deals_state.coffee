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

helpers = 
  commas: system.load.helper 'commas'

exports.index = (req,res) ->
  res.render 'deals/states/index'
  
exports.view = (req,res) ->
  models.properties.getAllPropertiesByState req.params.state, (err, results) ->
    if err then console.log err
    for i in [0...results.length]
      results[i].price = helpers.commas results[i].price
    res.render 'deals/states/deals', properties: results, menu: 'best-state-deal'
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->