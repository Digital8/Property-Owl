exports.index = (req, res) ->
  
  {query} = req
  
  Search.create query, (error, search) ->
    console.log arguments...
  
  query.stateQuery = if query.state isnt 'any'
    "state SOUNDS LIKE '#{query.state}' AND"
  else ''
  
  query.suburbQuery = if query.suburb?.length
     "suburb SOUNDS LIKE '#{query.suburb}' AND"
  else ''
  
  if query.minPrice is 'any' then query.minPrice = 0
  if query.maxPrice is 'any' then query.maxPrice = 99999999999
  
  if query.minBeds is 'any' then query.minBeds = 0
  if query.maxBeds is 'any' then query.maxBeds = 999
  
  if query.bathrooms is 'any' then query.bathrooms = 0
  
  if query.cars is 'any' then query.cars = 0
  
  query.developmentStatusQuery = if query.development_status_id?.length
    "development_type_id = #{query.development_status_id} AND"
  else ''
  
  query.developmentTypeQuery = if query.development_type_id?.length
    "development_type_id = #{query.development_type_id} AND"
  else ''
  
  Owl.search query, (err, results) ->
    if err then throw err
    res.render 'searchResults', search: results or {}