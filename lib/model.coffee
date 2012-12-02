async = require 'async'

{db} = require '../system'

module.exports = class Model
  @db = db
  
  constructor: (args = {}) ->
    for key, value of args
      @[key] = value
    
    @id = this[@constructor.table.key]
  
  hydrate: (callback) ->
    for key, field of @constructor.table.columns
      unless this[key]? then this[key] = ''
    
    callback null, this
  
  @new = (callback) ->
    model = new this
    model.hydrate callback
  
  @all = (callback) ->
    @db.query "SELECT * FROM #{@table.name}", (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        model = new this row
        models.push model
      
      async.forEach models, (model, callback) ->
        model.hydrate ->
          callback()
      , (error) ->
        callback null, models
  
  @delete = (id, callback) ->
    @db.query "DELETE FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error) =>
      return callback error if error
      
      callback null
  
  @get = (id, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE #{@table.key} = ?", [id], (error, rows) =>
      return callback error if error
      
      model = new this rows[0]
      
      model.hydrate callback

Model.db = db