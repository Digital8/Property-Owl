Query = require './query'

module.exports = class Resource
  
  @model = (value) ->
    @_ ?= {}
    @_.table = value if value?
    return @_.table
  
  @scope = (key, _query) ->
    @_ ?= {}
    @_.scopes ?= {}
    
    query = new Query _query
    
    @_.scopes[key] = query
    
    # console.log query.sql
  
  # @query = (args = {}) ->
  #   @_ ?= {}
  #   @_.queries ?= {}
    
  #   args.resource = this
  #   args.table = @model.table
  #   query = new Query args
  #   @_.queries[query.id] = query