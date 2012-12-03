uuid = require 'node-uuid'

async = require 'async'

{db} = require '../system'

module.exports = class Model
  @db = db
  
  @field = (key, args = {}) ->
    @fields ?= {}
    
    @fields[key] = args
  
  constructor: (args = {}) ->
    for key, value of args
      @[key] = value
    
    @id = this[@constructor.table.key]
  
  hydrate: (callback) ->
    # console.log 'constructor', @constructor
    
    for key, field of @constructor.table.columns
      continue if this[key]?
      
      if /int\(\d+\)/.test field.Type
        this[key] = 0
      else
        this[key] = ''
    
    callback null, this
  
  save: (callback) ->
    map = {}
    
    for key, field in @constructor.fields
      map[key] = @[key]
    
    # db.query "UPDATE #{@constructor.table.name} SET ?", map, callback
    callback()
  
  @update = (id, hash, callback) ->
    @get id, (error, owl) ->
      for key, field of @fields
        owl[key] = hash[key]
      
      owl.save (error) ->
        callback error, owl
  
  @new = (callback) ->
    model = new this
    model.hydrate callback
  
  @create = (map, callback) ->
    model = new this map
    
    hash = {}
    
    for key, field of @fields
      hash[key] = model[key]
    
    hash.created_at = 'NOW()'
    hash.updated_at = 'NOW()'
    
    model.hydrate (error, model) =>
      @db.query "INSERT INTO #{@table.name} SET ?", hash, (error, result) =>
        console.log arguments
        
        if error then return callback error
        
        id = result.insertId
        
        model.id = id
        model[@table.key] = id
        
        callback null, model
  
  @all = (callback) ->
    console.log uuid(), @name

    @db.query "SELECT * FROM #{@table.name}", (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        model = new this row
        models.push model
      
      async.forEach models, (model, callback) ->
        model.hydrate ->
          callback()
      , (error) ->
        callback null, models
  
  @delete = (id, callback) ->
    @db.query "DELETE FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error) =>
      return callback error if error
      
      callback null
  
  @get = (id, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      return callback error if error
      
      model = new this rows[0]
      
      model.hydrate callback

Model.db = db