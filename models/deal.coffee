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
  
  @field 'user_id'
  
  @field 'entity_id'
  
  @field 'type'
  
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
  
  @for = (model, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM deals WHERE entity_id = ? AND type = '#{type}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models

  @getByMonth = (cred, callback) ->
    if cred.month != ''
      @db.query "SELECT count(user_id) AS total, first_name, last_name, state, created_at FROM po_users  WHERE state LIKE ? AND MONTH(created_at) = ? GROUP BY state", [cred.state, cred.month], callback
    else
      @db.query "SELECT count(user_id) AS total, state, created_at FROM po_users  WHERE state LIKE % GROUP BY state", [cred.state], callback