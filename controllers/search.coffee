{models} = system = require '../system'

Search = models.search
Owl = models.owl

exports.index = (req, res) ->
  
  Search.create req.query, (error, search) ->
    console.log arguments...
  
  if req.query.state is 'all' then req.query.state = '%'
  if req.query.suburb is '' then req.query.suburb = '%' else req.query.suburb += '%'
  
  if req.query.development_type_id is 'any' then req.query.development_type_id = '%'
  
  if req.query.minPrice is 'any' then req.query.minPrice = 0
  if req.query.maxPrice is 'any' then req.query.maxPrice = 99999999999
  
  if req.query.minBeds is 'any' then req.query.minBeds = 0
  if req.query.maxBeds is 'any' then req.query.maxBeds = 999
  
  if req.query.bathrooms is 'any' then req.query.bathrooms = 0
  
  if req.query.cars is 'any' then req.query.cars = 0
  
  # if req.query.devStage is 'any' then req.query.devStage = '%'
  
  Owl.search req.query, (err, results) ->
    if err then throw err
    res.render 'searchResults', search: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->