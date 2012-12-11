_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Bookmark extends Model
  @table = new Table
    name: 'bookmarks'
    key: 'bookmark_id'
  
  @field 'owner_id'
  @field 'type'
  @field 'entity_id'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    async.parallel
      deal: (callback) =>
        if @type is 'owl'
          Owl = system.models.owl
          Owl.get @entity_id, callback
        
        if @type is 'barn'
          Barn = system.models.barn
          Barn.get @entity_id, callback
    
    , (error, results) =>
      @deal = results.deal
      super callback
  
  @forUser = (user, callback) =>
    system.db.query "SELECT * FROM #{@table.name} WHERE user_id = ?", [user.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) ->
        model.hydrate ->
          callback()
      , (error) ->
        callback null, models
  
  @forUserAndDeal = (user, deal, callback) =>
    type = deal.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM #{@table.name} WHERE entity_id = ? AND type = ? AND user_id = ? LIMIT 1", [deal.id, type, user.id], (error, rows) =>
      return callback error if error?
      
      return callback null, null unless rows?.length
      
      model = new this rows[0]
      
      model.hydrate callback
  
  # @for = (model, callback) =>
  #   type = model.constructor.name.toLowerCase()
    
  #   system.db.query "SELECT * FROM #{@table.name} WHERE entity_id = ? AND type = '#{type}'", [model.id], (error, rows) =>
  #     return callback error if error?
      
  #     models = []
      
  #     for row in rows
  #       model = new this row
  #       models.push model
      
  #     callback null, models