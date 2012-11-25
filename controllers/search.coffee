###
 * Search Controller
 *
 * Allows one to search for deals matching certain criteria
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###
system = require '../system'

models =
  properties: system.load.model('properties')

helpers = {}
 
exports.index = (req,res) ->
  
  
  
  if req.query.state is 'all' then req.query.state = '%'
  if req.query.pType is 'all' then req.query.pType = '%'
  if req.query.dType is 'all' then req.query.dType = '%'
  if req.query.minPrice is 'any' then req.query.minPrice = 0
  if req.query.maxPrice is 'any' then req.query.maxPrice = 99999999999
  if req.query.minBeds is 'any' then req.query.minBeds = 0
  if req.query.maxBeds is 'any' then req.query.maxBeds = 999
  if req.query.bathrooms is 'any' then req.query.bathrooms = 0
  if req.query.cars is 'any' then req.query.cars = 0
  if req.query.devStage is 'any' then req.query.devStage = '%'
    
  models.properties.search req.query, (err, results) ->
    if err then throw err
    res.render 'searchResults', search: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->