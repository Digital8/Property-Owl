uuid = require 'node-uuid'

async = require 'async'

###
Model
- represents a table statically i.e. `Model.foo` or `Model.bar`
- represents a record/row dynamically i.e. `record = new Model ; record.save()` 
- inspired by ActiveRecord/DataMapper/Mongoid
###
module.exports = class Model
  ###
  Model.field
  - used statically inside models to define columns/attributes in their schemas
  ###
  @field = (key, args = {}) ->
    @fields ?= {}
    
    args.cardinality ?= Infinity
    
    @fields[key] = args
  
  ###
  Model(map)
  - if passed a map (key/value pairs), copies over all key/values to the record
  - some fields are special i.e. `id`
  - take care with naming collisions (the `id`, `fields` properties are reserved)
  - i.e. `new Model`
  ###
  constructor: (args = {}) ->
    for key, value of args
      @[key] = value
    
    @id = this[@constructor.table.key]
  
  ###
  Model::hydrate
  - performs any async tasks that cannot be performed in the constructor due constructors being synchronous
  - consider .hydrate a gatekeeper to consult before relying on rows/records
  - sort of a hack [TODO] [@pyro]
  ###
  hydrate: (callback) ->
    for key, field of @constructor.table.columns
      continue if this[key]?
      
      if /int\(\d+\)/.test field.Type
        this[key] = 0
      else
        this[key] = ''
    
    callback null, this
  
  ###
  Model::save
  - commits/persists dirty fields (changes) to the underlying row/record
  ###
  save: (callback) ->
    map = {}
    
    for key, field of @constructor.fields
      map[key] = @[key]
    
    @constructor.db.query "UPDATE #{@constructor.table.name} SET ? WHERE #{@constructor.table.key} = ?", [map, @id], callback
    
    # console.log 'mapz', map
    
    # callback()
  
  ###
  Model::update
  - commits/persists dirty fields (changes) to the underlying row/record
  ###
  @update = (id, hash, callback) ->
    
    @get id, (error, model) ->
      
      for key, field of model.constructor.fields
        model[key] = hash[key]
      
      model.save (error) ->
        callback error, model
  
  ###
  Model.new
  - instantiates a new instance of the model (a record)
  - doesn't persist the new model to disk
  ###
  @new = (callback) ->
    model = new this
    model.hydrate callback
  
  ###
  Model::create
  - similar (shortcut) to using Model.new + model.save
  ###
  @create = (map, callback) ->
    model = new this map
    
    hash = {}
    
    for key, field of @fields
      hash[key] = model[key]
    
    hash.created_at = new Date
    hash.updated_at = new Date
    
    model.hydrate (error, model) =>
      @db.query "INSERT INTO #{@table.name} SET ?", hash, (error, result) =>
        # console.log arguments
        
        if error then return callback error
        
        id = result.insertId
        
        model.id = id
        model[@table.key] = id
        
        callback null, model
  
  ###
  Model.get | gets ALL records of a model
  - used in index/list actions
  - 
  ###
  @all = (callback) ->
    # console.log uuid(), @name

    @db.query "SELECT * FROM #{@table.name}", (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) ->
        model.hydrate ->
          callback()
      , (error) ->
        callback null, models
  
  ###
  Model.delete
  - deletes a record/row from the underlaying datasource by id
  ###
  @delete = (id, callback) ->
    @db.query "DELETE FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error) =>
      return callback error if error
      
      callback null
  
  ###
  Model::get
  - fetches a row from the underlying datasource
  - instantiates
  - needs alot of work [TODO] [@pyro]
  ###
  @get = (id, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      return callback error if error
      
      model = new this rows[0]
      
      model.hydrate callback
  
  ###
  Model::dry
  - fetches a row from the underlying datasource
  - does not hydrate (no associations)
  - needs alot of work [TODO] [@pyro]
  ###
  @dry = (id, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      return callback error if error
      
      model = new this rows[0]
      
      callback null, model