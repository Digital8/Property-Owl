system = require '../system'

async = require 'async'

models =
  properties: system.load.model('properties')
  deals: system.load.model('deals')

helpers = {}

i = 0
 
exports.index = (req,res) ->
  models.deals.getDealsByUserId res.locals.objUser.id, (err, results) ->
    if err then throw err
    res.render 'developers/deals/index', deals: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->
  models.properties.getPropertyByUserId res.locals.objUser.id , (err, properties) ->
    res.render 'developers/deals/add', properties: properties or {}

exports.create = (req,res) ->
  addDealFeatures = (value,cb) ->
    console.log "#{value}  = #{req.body.price[i]}"
    i++
    cb()
  
  # TODO Check that there are no existing deals for this property already
  # models.deals.getDealByPropertyId req.body.property
  
  async.map req.body.feature, addDealFeatures, (err, results) ->
    res.send req.body

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->