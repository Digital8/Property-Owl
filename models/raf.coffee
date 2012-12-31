async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class raf extends Model
  @table = new Table
    name: 'raf'
    key: 'raf_id'
  
  @field 'user_id'
  @field 'email'
  @field 'mobile'
  @field 'first_name'
  @field 'last_name'
  @field 'comment'
  @field 'entity_id'
  @field 'entity_type'
  @field 'created_at'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    super callback

  @getByUser: (user_id, callback) ->
    system.db.query "SELECT * FROM #{@table.name} WHERE user_id = ?", [user_id], (error, rows) =>
      callback(error, rows)