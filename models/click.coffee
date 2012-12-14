async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Click extends Model
  @table = new Table
    name: 'clicks'
    key: 'click_id'
  
  @field 'resource_id'
  @field 'user_id'
  @field 'type'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    super callback