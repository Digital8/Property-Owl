{models} = system = require '../system'

Search = models.search
Owl = models.owl

exports.index = (req, res) ->
  
  console.log req.query
  
  Search.create req.query, (error, search) ->
    console.log arguments...
  
  req.query.stateQuery = if req.query.state isnt 'any'
    "state SOUNDS LIKE '#{req.query.state}' AND"
  else ''
  
  req.query.suburbQuery = if req.query.suburb?.length
     "suburb SOUNDS LIKE '#{req.query.suburb}' AND"
  else ''
  
  if req.query.minPrice is 'any' then req.query.minPrice = 0
  if req.query.maxPrice is 'any' then req.query.maxPrice = 99999999999
  
  if req.query.minBeds is 'any' then req.query.minBeds = 0
  if req.query.maxBeds is 'any' then req.query.maxBeds = 999
  
  if req.query.bathrooms is 'any' then req.query.bathrooms = 0
  
  if req.query.cars is 'any' then req.query.cars = 0
  
  req.query.developmentStatusQuery = if req.query.development_status_id?.length
    "development_type_id = #{req.query.development_status_id} AND"
  else ''
  
  req.query.developmentTypeQuery = if req.query.development_type_id?.length
    "development_type_id = #{req.query.development_type_id} AND"
  else ''
  
  Owl.search req.query, (err, results) ->
    if err then throw err
    res.render 'searchResults', search: results or {}
  
exports.view = (req,res) ->
  
exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->
  
exports.update = (req,res) ->
  
exports.destroy = (req,res) ->