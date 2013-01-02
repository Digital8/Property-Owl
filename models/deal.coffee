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

    query = "SELECT U.first_name, U.last_name, U.state, U.created_at, O.approved, count(O.owl_id) as owl_count, count(B.barn_id) AS barn_count FROM po_users AS U LEFT JOIN owls as O ON U.user_id = O.listed_by LEFT JOIN barns as B ON B.listed_by = U.user_id WHERE"
    vals = []

    if cred.month != ''
      query += ' MONTH(O.created_at) = ? AND'
      vals.push(cred.month)

    if cred.developer != '0'
      query += ' U.user_id = ? AND'
      vals.push(cred.developer)

    query += ' O.state LIKE ?'

    vals.push(cred.state)

    ###if (cred.status != '-1')
      query += ' AND (O.approved = ? OR B.approved = ?)'
      vals.push(cred.status)
      vals.push(cred.status)###

    query += ' GROUP BY U.user_id, O.approved'

    console.log query

    @db.query "#{query}", vals, callback