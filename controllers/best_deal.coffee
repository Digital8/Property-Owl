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

helpers = {}
  
models =
  properties: system.load.model 'properties'
  deals: system.load.model 'deals'
  media: system.load.model 'media'

exports.index = (req,res) ->
  models.properties.getBestDeal (err, property) ->
    console.log arguments
    if err then console.log err
    unless property
      res.render 'properties/not_found'
    else
      models.deals.getDealsByPropertyId property.property_id, (err, deals) ->
        models.media.getMediaByPropertyId property.property_id, (err, files) ->
          models.media.getImagesByPropertyId property.property_id, (err, images) ->
            res.render 'deals/best_deal', menu: 'aus-best-deal', property: property, deals: deals or {}, files: files or {} , images: images or {}

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->
  
exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->

