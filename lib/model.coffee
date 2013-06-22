_ = require 'underscore'
async = require 'async'
uuid = require 'node-uuid'

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
    # args.cardinality ?= Infinity
    args.key ?= key
    @fields[key] = args
  
  ###
  Model.has
  - used statically inside models to define associations
  ###
  @has = (type, args = {}) ->
    @links ?= {}
    args.type ?= type
    args.cardinality ?= Infinity
    args.key ?= type.name.toLowerCase()
    @links[args.key] = args
  
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
    
    for key, field of @constructor.fields
      if field.default?
        @[key] ?= _.result field, 'default'
  
  set: (hash) ->
    
    for key, field of @constructor.fields when hash[key]?
      
      if field.type? and field.type is Boolean
        
        value = hash[key]
        
        map =
          true: true
          false: false
          on: on
          off: off
          0: false
          1: true
        
        @[key] = map[value]
      
      else
        
        @[key] = hash[key]
    
    return
  
  validate: (args = {}, callback) ->
    
    errors = {}
    
    emit = (field, message) ->
      errors[field.key] ?= []
      errors[field.key].push message
    
    console.log 'validating'
    
    for key, field of @constructor.fields
      
      value = @[key]
      
      console.log 'validating', key, field
      
      if field.required
        
        if field.type is String
          
          if _.isString value
            unless value.length
              emit field, 'length'
          else
            emit field, 'type'
    
    if (Object.keys errors).length
      callback {errors}
    else
      callback null
  
  ###
  Model::hydrate
  - performs any async tasks that cannot be performed in the constructor due constructors being synchronous
  - consider .hydrate a gatekeeper to consult before relying on rows/records
  - sort of a hack [TODO] [@pyro]
  ###
  hydrate: (callback) ->
    for key, field of @constructor.table.columns
      continue if this[key]?
      continue if @constructor?.fields?[key]?.null
      
      if /int\(\d+\)/.test field.Type
        this[key] = 0
      else
        this[key] = ''
    
    if @constructor.fields?
      
      for key, field of @constructor.table.columns
        if @constructor.fields?[key]?.type?
          if @constructor.fields?[key]?.type is Boolean
            # console.log 'TYPE', key, this[key], typeof this[key] # @constructor.fields[key]?.type
            this[key] = Boolean this[key]
    
    callback null, this
  
  ###
  Model::save
  - commits/persists dirty fields (changes) to the underlying row/record
  ###
  save: (callback) ->
    
    map = {}
    
    for key, field of @constructor.fields
      
      map[key] = @[key]
    
    @constructor.db.query "UPDATE #{@constructor.table.name} SET ? WHERE #{@constructor.table.key} = ?", [map, @id], (error, result) ->
      
      callback error result
  
  clone: (callback) ->
    
    map = {}
    
    for key, field of @constructor.fields
      
      map[key] = @[key]
    
    @constructor.create map, callback
  
  @build = (req, callback) ->
    
    @create req.body, (error, instance) =>
      
      return callback error if error?
      
      async.map (_.values @links), (link, callback) =>
        constructor = do link.type
        constructor.build req, (error, linked) =>
          return callback error if error?
          instance[link.key] = linked
          callback null
      , callback
  
  ###
  Model.patch
  - persists certain fields (changes) to the underlying row/record
  - bit of a hack
  ###
  @patch = (id, hash, callback) ->
    
    @get id, (error, model) =>
      
      return callback error if error?
      
      values = {}
      
      for key, field of @fields when hash[key]?
        
        # store old value (for changes / diffs)
        values[key] ?= {}
        values[key].old = model[key]
        
        # determine new value
        value = if field.type? and field.type is Boolean
          {true: true, false: false}[hash[key]]
        else
          hash[key]
        
        # update the model
        model[key] = value
        
        # store the new value (for changes / diffs)
        values[key].new = model[key]
      
      map = {}
      
      for key, value of hash
        map[key] = model[key]
      
      model.validate {}, (error) =>
        
        return callback error if error?
        
        @db.query "UPDATE #{@table.name} SET ? WHERE #{@table.key} = ?", [map, model.id], (error) =>
          
          for key in (Object.keys hash)
            
            continue unless values[key]?
            
            if values[key].new isnt values[key].old
              
              model.constructor.change?[key]? values: values[key], model: model
          
          callback error, model
  
  ###
  Model.update
  - persists dirty fields (changes) to the underlying row/record
  ###
  @update = (id, hash, callback) ->
    
    @get id, (error, model) =>
      
      model.set hash
      
      model.validate {}, (error) =>
        
        return callback error if error?
        
        model.save (error) =>
          
          callback error, model
  
  ###
  Model.new
  - instantiates a new instance of the model (a record)
  - doesn't persist the new model to disk
  ###
  @new = (args = {}, callback) ->
    model = new this args
    model.hydrate callback
  
  ###
  Model.create
  - similar (shortcut) to using Model.new + model.save
  ###
  @create = (map, callback) ->
    
    console.log 'creating', map
    
    @new map, (error, model) =>
      
      return callback error if error?
      
      hash = {}
      
      for key, field of @fields
        
        continue if key is @table.key
        
        continue unless model[key]?
        
        hash[key] = model[key]
      
      hash.created_at = new Date
      hash.updated_at = new Date
      
      model.validate {}, (error) =>
        
        return callback error if error?
        
        @db.query "INSERT INTO #{@table.name} SET ?", hash, (error, result) =>
          
          return callback error if error?
          
          id = result.insertId
          
          model.id = id
          
          model[@table.key] = id
          
          callback null, model
  
  ###
  Model.get
  - gets ALL records of a model
  - used in index/list actions
  ###
  @all = (callback) ->
    
    @db.query "SELECT * FROM #{@table.name} ORDER BY #{@table.key}", (error, rows) =>
      
      return callback error if error?
      
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
      
      return callback error if error?
      
      callback arguments...
  
  ###
  Model.get
  - fetches a row from the underlying datasource
  - instantiates
  - needs alot of work [TODO] [@pyro]
  ###
  @get = (id, callback) ->
    
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      
      return callback error if error?
      return callback null, null unless rows.length
      
      @new rows[0], callback
  
  ###
  Model.dry
  - fetches a row from the underlying datasource
  - does not hydrate (no associations)
  - needs alot of work [TODO] [@pyro]
  ###
  @dry = (id, callback) ->
    
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      
      return callback error if error?
      return callback null, null unless rows.length
      
      model = new this rows[0]
      
      callback null, model