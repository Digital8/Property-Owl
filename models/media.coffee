_ = require 'underscore'
async = require 'async'
cloudy = require 'cloudy'
mime = require 'mime'
request = require 'request'
uuid = require 'node-uuid'

Model = require '../lib/model'
Table = require '../lib/table'

cloud = new cloudy.Cloud
cloud.use 'fs', (require '../config').fs, ->
cloud.use 's3', (require '../config').s3, ->

config = require '../config'

module.exports = class Media extends Model
  
  @table = new Table
    name: 'medias'
    key: 'media_id'
  
  @field 'user_id'
  @field 'entity_id'
  @field 'entity_type'
  @field 'filename'
  @field 'key'
  @field 'description'
  @field 'deleted', type: Boolean, default: no
  @field 'mime'
  
  constructor: (args = {}) ->
    
    super
    
    Object.defineProperty this, 'url', get: =>
      "https://propertyowl.s3.amazonaws.com/#{@filename}"
    
    Object.defineProperty this, 'thumbnail', get: =>
      
      ext = @extension # or 'ini'
      
      if ext in config.mimes.image
        @url
      else
        if ext is 'mp4' then ext = 'mpeg'
        "https://digital8.s3.amazonaws.com/mime/#{ext}/#{ext}-128_32.png"
    
    Object.defineProperty this, 'extension', get: =>
      mime.extension @mime or 'application/octet-stream'
    
    unless @mime?.length
      url = "https://propertyowl.s3.amazonaws.com/#{@filename}"
      console.log 'fetching mime', url
      request.head url, (error, response, body) =>
        @patch mime: response?.headers?['content-type'], (error) =>
          console.log 'error fetching mime', error if error?
    
    # Object.defineProperty this, 'mime', get: =>
    #   @_mime or 'application/octet-stream'
  
  # hydrate: (callback) ->
    
  #   if global.cache?[@id]?.mime?
  #     @_mime = global.cache[@id].mime
  #     super callback
  #   else
  #     url = "https://propertyowl.s3.amazonaws.com/#{@filename}"
  #     console.log 'fetching', url
  #     request.head url, (error, response, body) =>
        
  #       unless error?
          
  #         type = response?.headers?['content-type']
          
  #         @_mime = type
          
  #         global.cache ?= {}
  #         global.cache[@id] ?= {type}
        
  #       super callback
  
  @build = (req, args..., callback) ->
    
    link = args[0]?.link
    return callback null unless link?
    return callback null unless req.files[link.key]?
    
    files = _.array req.files[link.key]
    
    async.map files, (file, callback) =>
      
      @create
        entity_type: req.body.entity_type
        entity_id: req.body.entity_id
        user_id: req.user.id
        filename: uuid()
        key: link.tag
        description: file.name
      , (error, instance) =>
        
        return callback error if error?
        
        file = new cloudy.File
          id: instance.filename
          path: file.path
        
        cloud.file file, callback
    
    , callback
    
    # TODO recursive links
  
  @upload = (args, callback) =>
    
    {req, file} = args
    
    console.log file
    
    @create
      user_id: req.user.id
      filename: uuid()
      key: 'file'
      description: file.name
      entity_type: 'file'
      entity_id: 0
    , (error, instance) =>
      
      return callback error if error?
      
      file = new cloudy.File
        id: instance.filename
        path: file.path
      
      cloud.file file, callback
  
  @type = (type, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE entity_type = ?", type, (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  @for = (model, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE entity_id = ? AND entity_type = ?", [
      model.id
      model.constructor.name.toLowerCase()
    ], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback