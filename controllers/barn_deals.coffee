###
 * Barn Deals
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
  properties: system.load.model('properties')
  media: system.load.model('media')
  lots: system.load.model('lots')
  deals: system.load.model('deals')

# GET
exports.index = (req,res) ->
  models.properties.getPropertiesByDealType 'barn', true, (err, results) ->
    if err then console.log err
    res.render 'barn_deals/index', barn: results

# GET    
exports.view = (req,res) ->
  models.properties.getAllPropertiesById req.params.id, (err, results) ->
    if err then throw err
    if results.length is 0
      res.render 'barn_deals/404'
    else    
      property = results.pop()
      if property.deal_type.toLowerCase() != 'barn' and property.deal_type.toLowerCase() != 'all'
        res.render 'barn_deals/404'
      else
        # Get the deals
        #models.properties.getPropertiesOfBarnDeal req.params.id, (err, barn_deals) ->
        models.deals.getDealsByPropertyId req.params.id, (err, deals) ->
          models.media.getMediaByPropertyId req.params.id, (err, files) ->
            models.media.getImagesByPropertyId req.params.id, (err, images) ->
              models.lots.getLotsByPropertyId req.params.id, (err,lots) ->
                res.render 'barn_deals/view', property: property, deals: deals or {}, files: files or {}, images: images or {}, lots: lots or {}

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

