_ = require 'underscore'
async = require 'async'

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

  constructor: (args = {}) ->
    super

  @report = (cred, callback) ->
    query = "SELECT S.state, count(S.search_id) AS total, S.created_at as date FROM searches as S GROUP BY state "
    vals = []

    @db.query query, vals, callback