async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Post extends Model
  
  @table = new Table
    name: 'posts'
    key: 'post_id'
  
  @field 'title'
  @field 'content'
  @field 'created_at'
  @field 'type'
  
  hydrate: (callback) ->
    Media.for this, (error, medias) =>
      @images = medias
      super callback
  
  upload: (req, callback) ->
    return callback null unless req.files? and (Object.keys req.files).length
    
    async.forEach (Object.keys req.files), (key, callback) =>
      file = req.files[key]
      
      if file.size <= 0 then return callback null
      
      Media.upload
        entity_id: @id
        owner_id: req.session.user_id
        file: file
        type: 'post'
      , (error, media) ->
        callback error, media
    
    , callback
  
  @findByType = (type, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE type = ? ORDER BY created_at DESC", [type], (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)

      async.forEach models, (model, callback) ->
        model.hydrate ->
          callback()
      , (error) ->
        callback null, models

  imageURL: ->
    if @images.length
      return @images.pop().filename
    else
      return '/placeholder.png' # or whatever it is