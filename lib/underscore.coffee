_ = require 'underscore'

_.array = (object) ->
  
  return object if _.isArray object
  
  return [object]