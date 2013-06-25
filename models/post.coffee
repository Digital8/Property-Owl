async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Post extends Model
  
  @table = new Table
    name: 'posts'
    key: 'post_id'
  
  @has (-> Media), key: 'image', cardinality: 1
  
  @field 'title'
  @field 'content'
  @field 'created_at'
  @field 'type'
  
  constructor: (args = {}) ->
    
    super
    
    @_image = null
    Object.defineProperty this, 'image',
      get: =>
        return @_image if @_image
        return {
          url: "/images/placeholder.png"
          thumbnail: "/images/placeholder.png"
        }
      set: (value) => @_image = value
  
  @findByType = (type, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE type = ? ORDER BY created_at DESC", [type], (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)

      async.forEach models, (model, callback) ->
        model.hydrate ->
          callback()
      , (error) ->
        callback null, models
