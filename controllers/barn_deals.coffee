system = require '../system'

helpers = hash: system.load.helper 'hash'
  
models = 
  properties: system.load.model 'properties'
  lots: system.load.model 'lots'
  deals: system.load.model 'deals'

exports.index = (req,res) ->
  models.properties.getPropertiesByDealType 'barn', true, (err, results) ->
    if err then console.log err
    
    res.render 'barn_deals/index', barn: results

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
        models.deals.getDealsByPropertyId req.params.id, (err, deals) ->
          
          models.lots.getLotsByPropertyId req.params.id, (err,lots) ->
            
            res.render 'barn_deals/view'
              property: property
              lots: lots or {}
              deals: deals or {}

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->