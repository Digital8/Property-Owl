#JS implementation of mysql real escape string
#Docs at: http://php.net/manual/en/function.mysql-real-escape-string.php
mysql_real_escape_string = (str) ->
  str.replace /[\0\x08\x09\x1a\n\r"'\\\%]/g, (char) ->
    switch char
      when "\u0000"
        "\\0"
      when "\b"
        "\\b"
      when "\t"
        "\\t"
      when "\u001a"
        "\\z"
      when "\n"
        "\\n"
      when "\r"
        "\\r"
      when "\"", "'", "\\", "%"
        "\\" + char

exports.index = (req, res) ->
  
  {query} = req

  Search.create query, (error, search) ->
    console.log arguments...
  
  if query.state isnt 'any'
    query.state = mysql_real_escape_string query.state
    query.stateQuery = "state SOUNDS LIKE '#{query.state}' AND"
  else query.stateQuery = ''
  
  if query.suburb?.length
    query.suburb = mysql_real_escape_string query.suburb
    query.suburbQuery = "suburb SOUNDS LIKE '#{query.suburb}' AND"
  else query.suburbQuery = ''
  
  if query.minPrice is 'any' then query.minPrice = 0
  query.minPrice = parseInt query.minPrice
  
  if query.maxPrice is 'any' then query.maxPrice = 99999999999
  query.maxPrice = parseInt query.maxPrice
  
  if query.minBeds is 'any' then query.minBeds = 0
  query.minBeds = parseInt query.minBeds

  if query.maxBeds is 'any' then query.maxBeds = 999
  query.maxBeds = parseInt query.maxBeds
  
  if query.bathrooms is 'any' then query.bathrooms = 0
  query.bathrooms = parseInt query.bathrooms
  
  if query.cars is 'any' then query.cars = 0
  query.cars = parseInt query.cars
  
  if query.development_status_id?.length
    query.development_status_id = parseInt query.development_status_id
    query.developmentStatusQuery = "development_type_id = #{query.development_status_id} AND"
  else query.developmentStatusQuery = ''
  
  if query.development_type_id?.length
    query.development_type_id = parseInt query.development_type_id
    query.developmentTypeQuery = "development_type_id = #{query.development_type_id} AND"
  else query.developmentTypeQuery = ''
  
  Owl.search query, (err, results) ->
    if err then throw err
    res.render 'searchResults', search: results or {}
