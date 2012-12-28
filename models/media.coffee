fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Media extends Model
  @table = new Table
    name: 'medias'
    key: 'media_id'
  
  # @belongsTo Model, as: 'owner'
  # @blongsTo Model, as: 'entity'
  
  @field 'owner_id'
  @field 'entity_id'
  @field 'filename'
  @field 'type'
  @field 'class'
  @field 'description'
  
  constructor: (args = {}) ->
    
    super
  
  hydrate: (callback) ->

    super callback
  
  @upload = (args, callback) =>
    id = uuid() + '.png'
    
    {file, entity_id, owner_id, type} = args
    klass = args.class
    
    fs.readFile file.path, (error, data) =>
      path = "#{system.bucket}/#{id}"
      
      fs.writeFile path, data, (error) =>
        @create
          entity_id: entity_id
          owner_id: owner_id
          filename: id
          type: type
          class: klass
          description: file.name
        , callback
  
  @for = (model, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM medias WHERE entity_id = ? AND type = '#{type}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models
  
  @forEntityWithClass = (model, {klass}, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM medias WHERE entity_id = ? AND type = '#{type}' AND class = '#{klass}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models