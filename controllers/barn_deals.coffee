###
 * Sign Up Controller
 *
 * Controller for homepage of website
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

helpers = 
  hash: system.load.helper('hash')
  
models = 
  properties: system.load.model 'properties'

# GET
exports.index = (req,res) ->
  models.properties.getPropertiesByDealType 'barn', true, (err, results) ->
    if err then throw err
    res.render 'barn_deals/index', barn: results

# GET    
exports.view = (req,res) ->
  models.properties.getAllPropertiesById req.params.id, (err, results) ->
    if err then throw err
    property = results.pop()
    if property.deal_type.toLowerCase() != 'barn' and property.deal_type.toLowerCase() != 'all'
      res.send 'no barn deal found for this ID'
    else
      res.render 'barn_deals/view', property: property, barn_deals: {}

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

