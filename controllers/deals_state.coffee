system = require '../system'

models = properties: system.load.model 'properties'

helpers = commas: system.load.helper 'commas'

exports.index = (req,res) ->
  models.properties.getBestStateDeals (err, results) ->
    if err then console.log err
    
    for i in [0...results.length]
      results[i].price = helpers.commas results[i].price
    
    res.render 'deals/states/index', properties: results, menu: 'best-state-deals'

exports.view = (req,res) ->
  models.properties.getAllPropertiesByState req.params.state, (err, results) ->
    if err then console.log err
    for i in [0...results.length]
      results[i].price = helpers.commas results[i].price
    res.render 'deals/states/deals', properties: results, state: req.params.state

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->

exports.destroy = (req,res) ->