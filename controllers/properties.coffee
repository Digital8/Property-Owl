system = require '../system'

models =
  properties: system.load.model('properties')
  media: system.load.model('media')
  deals: system.load.model('deals')

helpers = {}
 
exports.index = (req,res) ->
  
exports.view = (req,res) ->
  models.properties.getAllPropertiesById req.params.id, (err, results) ->
    if err then console.log err
    if results.length is 0
      res.render 'properties/not_found'
    else
      models.deals.getDealsByPropertyId req.params.id, (err, deals) ->
        models.media.getMediaByPropertyId req.params.id, (err, files) ->
          models.media.getImagesByPropertyId req.params.id, (err, images) ->
            res.render 'properties/view', property: results.pop(), deals: deals or {}, files: files or {} , images: images or {}, exclusive: yes
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->