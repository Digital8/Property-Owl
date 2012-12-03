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