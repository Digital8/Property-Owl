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