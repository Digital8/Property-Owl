cloudy = require 'cloudy'
# mmmagic = require 'mmmagic'
# magic = new mmmagic.Magic mmmagic.MAGIC_MIME_TYPE

Model = require '../lib/model'
Table = require '../lib/table'

cloud = new cloudy.Cloud
cloud.use 's3', (require '../config').s3, ->
  console.log 'cloud'

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