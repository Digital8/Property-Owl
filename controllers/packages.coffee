{models} = require '../system'

# models =
#   properties: system.load.model 'properties'
#   media: system.load.model 'media'
#   lots: system.load.model 'lots'
#   deals: system.load.model 'deals'

exports.index = (req, res) ->
  models.properties.all (err, properties) ->
    prop = []
    
    if err then console.log err
    
    res.render 'barn_deals/index', barn: results

exports.view = (req, res) ->
  models.properties.getAllPropertiesById req.params.id, (err, results) ->
    if err then throw err
    
    if results.length is 0
      res.render 'barn_deals/404'
    else    
      property = results.pop()
      
      if property.deal_type.toLowerCase() isnt 'barn' and property.deal_type.toLowerCase() isnt 'all'
        res.render 'barn_deals/404'
      else
        models.deals.getDealsByPropertyId req.params.id, (err, deals) ->
          models.media.getMediaByPropertyId req.params.id, (err, files) ->
            models.media.getImagesByPropertyId req.params.id, (err, images) ->
              models.lots.getLotsByPropertyId req.params.id, (err,lots) ->
                res.render 'barn_deals/view'
                  property: property
                  deals: deals or {}
                  files: files or {}
                  images: images or {}
                  lots: lots or {}

exports.add = (req, res) ->

exports.create = (req, res) ->

exports.edit = (req, res) ->

exports.update = (req, res) ->

exports.destroy = (req, res) ->