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
    
    @set args
    
    @id = @[@constructor.table.key]
    
    do @default
  
  default: ->
    for key, field of @constructor.fields when field.default?
      @[key] ?= (field.default? null) or field.default
  
  cast: (key, value) ->
    
    field = @constructor.fields[key]
    
    if field?.type is Boolean
      
      return {
        true: true
        false: false
        on: on
        off: off
        yes: yes
        no: no
        0: false
        1: true
      }[value]
    
    return value
  
  set: (hash) ->
    
    for key, value of hash
      
      @[key] = @cast key, value
    
    return
  
  patchLinks: (hash, args..., callback) ->
    
    req = args[0]?.req
    
    return callback null unless req
    
    async.map (_.values @constructor.links), (link, callback) =>
      
      return callback null unless req.body?[link.key]? or req.files?[link.key]?
      
      constructor = do link.type
      
      task = if link.cardinality isnt Infinity
        (callback) =>
          # delete existing linked models
          constructor.forEntity this, (error, linkedModels) =>
            
            return calback error if error?
            
            async.map linkedModels, (linkedModel, callback) =>
              linkedModel.patch deleted: yes, callback
            , callback
      else (callback) -> callback null
      
      task callback
    
    , (error) =>
      
      return callback error if error?
      
      @buildLinks req, callback
  
  patch: (hash, args..., callback) ->
    
    for key, field of @constructor.fields when field.type is Boolean
      hash[key] ?= false
    
    @set hash
    
    map = {}
    for key, field of @constructor.fields when key of hash
      map[key] = @[key]
    
    @validate {}, (error) =>
      
      return callback error if error?
      
      task = if _.size map
        (callback) =>
          @constructor.db.query """
          UPDATE #{@constructor.table.name}
          SET ?
          WHERE #{@constructor.table.key} = ?
          """, [map, @id], callback
      else (callback) -> callback null
      
      task (error) =>
        
        return callback error if error?
        
        @patchLinks hash, args..., callback
  
  validate: (args = {}, callback) ->
    
    errors = {}
    
    emit = (field, message) ->
      errors[field.key] ?= []
      errors[field.key].push message
    
    for key, field of @constructor.fields
      
      value = @[key]
      
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
    
    # for key, field of @constructor.table.columns
      
    #   continue if this[key]?
      
    #   continue if @constructor?.fields?[key]?.null
      
    #   if /int\(\d+\)/.test field.Type
    #     this[key] = 0
    #   else
    #     this[key] = ''
    
    if @constructor.fields?
      
      for key, field of @constructor.table.columns
        if @constructor.fields?[key]?.type?
          if @constructor.fields?[key]?.type is Boolean
            this[key] = Boolean this[key]
    
    async.map (_.values @constructor.links), (link, callback) =>
      
      model = do link.type
      
      task = if link.cardinality is Infinity
        (callback) => model.forEntityByKey this, link.tag, callback
      else
        (callback) => model.forEntity this, callback
      
      task (error, linked) =>
        
        return callback error if error?
        
        if link.cardinality is Infinity
          @[link.key] = linked
        else
          # TODO check for ambiguity
          @[link.key] = linked[0]
        
        callback null
    
    , (error) =>
      
      return callback error if error?
      
      callback null, this
  
  ###
  Model::save
  - commits/persists dirty fields (changes) to the underlying row/record
  ###
  save: (callback) ->
    
    map = {}
    
    for key, field of @constructor.fields
      
      map[key] = @[key]
    
    @constructor.db.query """
    UPDATE #{@constructor.table.name}
    SET ?
    WHERE #{@constructor.table.key} = ?
    """, [map, @id], (error, result) ->
      
      callback error, result
  
  clone: (callback) ->
    
    map = {}
    
    for key, field of @constructor.fields
      
      map[key] = @[key]
    
    @constructor.create map, callback
  
  buildLinks: (req, callback) ->
    
    async.map (_.values @constructor.links), (link, callback) =>
      
      return callback null unless req.body?[link.key]? or req.files?[link.key]?
      
      constructor = do link.type
      
      req.body.entity_id = @id
      req.body.entity_type = @constructor.name.toLowerCase()
      
      constructor.build req, link: link, (error, linked) =>
        return callback error if error?
        @[link.key] = linked
        callback null
    
    , callback
  
  @forEntity = (entity, callback) ->
    
    @db.query """
    SELECT *
    FROM #{@table.name}
    WHERE
      entity_id = ?
      AND entity_type = ?
      AND NOT deleted
    """, [
      entity.id
      entity.constructor.name.toLowerCase()
    ], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  @forEntityByKey = (entity, key, callback) ->
    
    @db.query """
    SELECT *
    FROM #{@table.name}
    WHERE
      entity_id = ?
      AND entity_type = ?
      AND `key` = ?
      AND NOT deleted
    """, [
      entity.id
      entity.constructor.name.toLowerCase()
      key
    ], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  @build = (req, callback) ->
    
    @create req.body, (error, instance) =>
      
      return callback error if error?
      
      instance.buildLinks req, (error, results) =>
        
        return callback error if error?
        
        callback null, instance
  
  ###
  Model.patch
  - persists certain fields (changes) to the underlying row/record
  - bit of a hack
  ###
  @patch = (id, hash, args..., callback) ->
    
    @get id, (error, model) =>
      
      return callback error if error?
      
      model.patch hash, args..., (error, patches) =>
        
        return callback error if error?
        
        callback null, model
  
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
    
    for key, field of @fields when field.type is Boolean
      map[key] ?= false
    
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
    
    # ORDER BY #{@table.key}
    @db.query "SELECT * FROM #{@table.name}", (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  ###
  Model.delete
  - deletes a record/row from the underlaying datasource by id
  ###
  @delete = (id, callback) ->
    
    @db.query "DELETE FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error) =>
      
      return callback error if error?
      
      # needs mysql results (affectedRows)
      callback arguments...
  
  ###
  Model.get
  - fetches a row from the underlying datasource
  - instantiates
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
  ###
  @dry = (id, callback) ->
    
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      
      return callback error if error?
      return callback null, null unless rows.length
      
      callback null, (new this rows[0])