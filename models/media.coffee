fs = require 'fs'

async = require 'async'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

{Magic, MAGIC_MIME_TYPE} = require 'mmmagic'

module.exports = class Media extends Model
  @table = new Table
    name: 'medias'
    key: 'media_id'
  
  # @belongsTo Model, as: 'owner'
  # @blongsTo Model, as: 'entity'
  
  @field 'owner_id'
  @field 'entity_id'
  @field 'filename'
  @field 'type'
  @field 'class'
  @field 'description'
  
  constructor: (args = {}) ->
    
    super
  
  hydrate: (callback) ->

    super callback
  
  @upload = (args, callback) =>
    
    {file, entity_id, owner_id, type} = args
    klass = args.class
    
    magic = new Magic MAGIC_MIME_TYPE
    
    map =
      'image/jpeg':
        ext: '.jpg'
      'image/png':
        ext: '.png'
      'application/pdf':
        ext: '.pdf'
      'video/x-flv':
        ext: '.flv'
      'video/mp4':
        ext: '.mp4'
      'application/x-mpegURL':
        ext: '.m3u8'
      'video/MP2T':
        ext: '.ts'
      'video/3gpp':
        ext: '.mov'
      'video/x-msvideo':
        ext: '.avi'
      'video/x-ms-wmv':
        ext: '.wmv'
      'application/x-shockwave-flash':
        ext: '.swf'
    
    magic.detectFile file.path, (error, mime) =>
      return callback 'bad mime' if error?
      
      return callback 'Unacceptable file type. Must be a valid media file (image, document, video).' unless map[mime]?
      
      fs.readFile file.path, (error, data) =>
        id = uuid()
        
        filename = "#{id}#{map[mime].ext}"
        
        path = "#{system.bucket}/#{filename}"
        
        fs.writeFile path, data, (error) =>
          @create
            entity_id: entity_id
            owner_id: owner_id
            filename: filename
            type: type
            class: klass
            description: file.name
          , callback
  
  @type = (type, callback) =>
    
    system.db.query "SELECT * FROM medias WHERE type = ?", type, (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models
  
  @for = (model, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM medias WHERE entity_id = ? AND type = '#{type}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models
  
  @forEntityWithClass = (model, {klass}, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM medias WHERE entity_id = ? AND type = '#{type}' AND class = '#{klass}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models