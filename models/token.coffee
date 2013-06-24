async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Token extends Model
  
  @table = new Table
    name: 'tokens'
    key: 'token_id'
  
  @field 'user_id'
  
  @field 'uuid', default: uuid
  
  @field 'key', default: 'master'
  
  @field 'entity_id'
  @field 'entity_type'
  
  @field 'created_at'
  @field 'updated_at'
  
  hydrate: (callback) ->
    async.parallel
      user: (callback) => User.dry @user_id, callback
      entity: (callback) => @constructor.models[@entity_type].dry @entity_id, callback
    , (error, map) =>
      return callback error if error?
      {@user, @entity} = map
      super callback
  
  @byUUID = (uuid, callback) ->
    
    @db.query """
    SELECT *
    FROM #{@table.name}
    WHERE uuid = ?
    """, [uuid], (error, rows) =>
      
      return callback error if error?
      
      # none
      return callback null, null unless rows.length
      
      # many/one
      @new rows[0], callback
  
  @for = (entity, args..., callback) =>
    
    @db.query """
    SELECT *
    FROM #{@table.name}
    WHERE entity_id = ? AND entity_type = ?
    """, [
      entity.id
      entity.constructor.name.toLowerCase()
    ], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  @forEntityByKey = (entity, key, args..., callback) =>
    
    @db.query """
    SELECT *
    FROM #{@table.name}
    WHERE entity_id = ? AND entity_type = ? AND `key` = ?
    """, [
      entity.id
      entity.constructor.name.toLowerCase()
      key
    ], (error, rows) =>
      
      return callback error if error?
      
      # none
      return callback null, null unless rows.length
      
      # many
      # return callback 'ambiguous' if rows.length > 1
      
      # many/one
      @new rows[0], callback
  
  @createForEntityWithKey = (entity, key, map, callback) =>
    
    map.entity_id ?= entity.id
    map.entity_type ?= entity.constructor.name.toLowerCase()
    map.key ?= key
    
    @create map, callback
  
  @upsertForEntityByKey = (entity, key, map, callback) =>
    
    @forEntityByKey entity, key, (error, token) =>
      
      return callback error if error?
      
      return callback null, token if token?
      
      @createForEntityWithKey entity, key, map, callback