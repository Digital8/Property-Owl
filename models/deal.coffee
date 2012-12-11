fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Deal extends Model
  @table = new Table
    name: 'deals'
    key: 'deal_id'
  
  # @belongsTo Model, as: 'owner'
  # @blongsTo Model, as: 'entity'
  
  @field 'value'
  @field 'description'
  @field 'deal_type_id'
  
  # @field 'owner_id'
  # @field 'entity_id'
  # @field 'filename'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    async.parallel
      developmentType: (callback) =>
        DealType = system.models.deal_type
        
        DealType.get @deal_type_id, (error, dealType) =>
          @type = dealType
          
          callback()
    , (error) =>
      super callback
  
  # @upload = (args, callback) =>
  #   id = uuid()
  
  #   console.log 'uploading...', file
  
  #   {file, entity_id, owner_id} = args
  
  #   fs.readFile file.path, (error, data) =>
  #     path = "#{system.bucket}/#{id}"
  
  #     fs.writeFile path, data, (error) =>
  #       @create
  #         entity_id: entity_id
  #         owner_id: owner_id
  #         filename: id
  #       , callback
  
  # @for = (model, callback) =>
  #   @all (error, callback) ->
  #     console.log 'media', arguments
  
  @for = (model, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM deals WHERE entity_id = ? AND type = '#{type}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models