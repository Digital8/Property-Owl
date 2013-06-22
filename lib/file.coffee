{EventEmitter} = require 'events'

uuid = require 'node-uuid'

module.exports = class File extends EventEmitter
  
  constructor: (args = {}) ->
    
    super
    
    @[key] = value for key, value of args
    
    @id ?= uuid()
  
  hydrate: (callback) ->
    
    callback null
  
  upload: ->
    
    {file, entity_id, owner_id, type} = args
    klass = args.class
    
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