async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Bookmark extends Model
  
  @table = new Table
    name: 'bookmarks'
    key: 'bookmark_id'
  
  @field 'user_id'
  @field 'type'
  @field 'entity_id'
  
  hydrate: (callback) ->
    async.parallel
      deal: (callback) =>
        
        console.log @type, @entity_id
        
        if @type is 'owl'
          Owl.get @entity_id, callback
        
        if @type is 'barn'
          Barn.get @entity_id, callback
    
    , (error, results) =>
      return callback error if error?
      @deal = results.deal
      super callback
  
  @forUser = (user, callback) =>
    
    return callback() unless user?
    
    @db.query "SELECT * FROM #{@table.name} WHERE user_id = ?", [user.id], (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) ->
        model.hydrate callback
      , (error) ->
        callback error, models
  
  @forUserAndDeal = (user, deal, callback) =>
    
    type = deal.constructor.name.toLowerCase()
    
    #if user isn't logged in
    unless user?
      callback null, null
      return
    
    @db.query "SELECT * FROM #{@table.name} WHERE entity_id = ? AND type = ? AND user_id = ? LIMIT 1", [deal.id, type, user.id], (error, rows) =>
      return callback error if error?
      
      return callback null, null unless rows?.length
      
      model = new this rows[0]
      
      model.hydrate callback