Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Search extends Model
  
  @table = new Table
    name: 'searches'
    key: 'search_id'
  
  @field 'state'
  @field 'suburb'
  
  @field 'development_type_id'
  
  @field 'minPrice'
  @field 'maxPrice'
  
  @field 'minBeds'
  @field 'maxBeds'
  
  @field 'bathrooms'
  
  @field 'cars'
  
  @report = (cred, callback) ->
    query = "SELECT * FROM searches AS S WHERE "
    vals = []
    
    if cred.month != ''
      query += "MONTH(S.created_at) = ? AND "
      vals.push(cred.month)
    
    if cred.state != '' and cred.state != 'all'
      query += 'S.state = ? AND '
      vals.push(cred.state)
    
    query += '1=1'
    
    @db.query query, vals, callback