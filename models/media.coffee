async = require 'async'
cloudy = require 'cloudy'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

cloud = new cloudy.Cloud
cloud.use 'fs', (require '../config').fs, ->
cloud.use 's3', (require '../config').s3, ->

module.exports = class Media extends Model
  
  @table = new Table
    name: 'medias'
    key: 'media_id'
  
  @field 'user_id'
  @field 'entity_id'
  @field 'entity_type'
  @field 'filename'
  @field 'class'
  @field 'description'
  
  constructor: (args = {}) ->
    
    super
    
    Object.defineProperty this, 'url', get: =>
      "https://propertyowl.s3.amazonaws.com/#{@filename}"
  
  @build = (req, callback) ->
    
    async.map (Object.keys req.files), (key, callback) =>
      
      file = req.files[key]
      
      return callback null unless file.size
      
      map =
        entity_type: req.body.entity_type
        entity_id: req.body.entity_id
        user_id: req.user.id
        filename: uuid()
        class: 'image'
        description: file.name
      
      @create map, (error, instance) =>
        
        return callback error if error?
        
        file = new cloudy.File
          id: instance.filename
          path: file.path
        
        cloud.file file, callback
    
    , callback
    
    # instance.buildLinks req, (error, instances) =>
    
    #   return callback error if error?
  
  @upload = (args, callback) =>
    callback null
  
  @type = (type, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE entity_type = ?", type, (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models
  
  @for = (model, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE entity_id = ? AND entity_type = ?", [
      model.id
      model.constructor.name.toLowerCase()
    ], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models
  
  @forEntityWithClass = (model, {klass}, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE entity_id = ? AND entity_type = ? AND class = ?", [
      model.id
      model.constructor.name.toLowerCase()
      klass
    ], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models