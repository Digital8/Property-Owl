async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Barn extends Model
  
  @table = new Table
    name: 'barns'
    key: 'barn_id'
  
  @field 'title'
  @field 'description'
  
  @field 'address'
  @field 'suburb'
  @field 'postcode'
  @field 'state'
  
  @field 'indoor_features'
  @field 'outdoor_features'
  @field 'other_features'
  
  @field 'listed_by'
  @field 'feature_image'
  
  @field 'approved', type: Boolean, default: no
  
  constructor: (args = {}) ->
    
    Object.defineProperty this, 'code',
      get: => _s.pad @id.toString(), 5, '0'
    
    Object.defineProperty this, 'url',
      get: => "/barns/#{@id}"
    
    Object.defineProperty this, 'fullAddress', get: =>
      (_.compact [@address, @suburb, @state.toUpperCase(), @postcode]).join ', '
    
    super
  
  hydrate: (callback) ->
    
    async.parallel
      
      owls: (callback) =>
        Owl.inBarn @id, (error, owls) =>
          @owls = owls
          do @tagOwls
          callback error
      
      # images: (callback) =>
      #   Media.forEntityWithClass this, klass: 'image', (error, medias) =>
          
      #     @images = medias
          
      #     if @feature_image? and @images.length
            
      #       feature_id = parseInt @feature_image
            
      #       feature_image = _.detect @images, (image) -> image.id is feature_id
            
      #       @images = _.filter @images, (image) -> image.id isnt feature_id
            
      #       @images.unshift feature_image
            
      #       @images = _.filter @images, (image) -> image?
          
      #     callback error
      
      # files: (callback) =>
      #   Media.forEntityWithClass this, klass: 'file', (error, medias) =>
      #     @files = medias
      #     callback error
      
      deals: (callback) =>
        Deal.for this, (error, deals) =>
          @deals = deals
          callback error
      
      user: (callback) =>
        User.get @listed_by, (error, user) =>
          return callback error if error?
          @user = user
          do callback
      
      registrations: (callback) =>
        @constructor.db.query """
        SELECT * FROM registrations AS R
        INNER JOIN users AS U ON R.user_id = U.user_id
        WHERE
          R.entity_type = 'barn'
          AND
        R.entity_id = ?
        """, [@id], (err, results) =>
          @registrations = results
          callback()
    
    , (error) =>
      @user ?= {}
      callback error, this
  
  tagOwls: ->
    for owl, index in @owls
      owl.index = index
      owl.alpha = 'ABCDE'[index]
  
  heroImageURL: ->
    
    unless @images? and @images.length then return '/images/placeholder.png'
    
    # find the hero
    hero = _.find @images, (image) =>
      return Number(image.id) is Number(@feature_image)
    
    # default to latest image
    hero ?= @images.pop()
    
    return "/uploads/#{hero.filename}"
  
  upload: (req, callback) ->
    
    processFiles = (req, key, callback = ->) =>
      files = req.files["#{key}s"]
      
      do callback unless files?
      
      files = [].concat files
      
      async.forEach files, (file, callback) =>
        console.log "processing #{key} file...", file
        
        return do callback unless file.size
        
        Media.upload
          entity_id: @id
          owner_id: req.user.id
          file: file
          type: 'barn'
          class: key
        , callback
      
      , callback
    
    # uploads
    
    async.series
      
      uploads: (callback) =>
        
        async.parallel
        
          image: (callback) =>
            processFiles req, 'image', callback
          
          file: (callback) =>
            processFiles req, 'file', callback
        
        , callback
      
      nested: (callback) =>
        return do callback unless req.body.files? 
        
        for file in req.body.files when file? and file.id? and file.description?
          Media.update file.id, description: file.description, ->
        
        do callback
    
    , (error) ->
      console.log 'done'
      do callback
  
  @byDeveloper = (id, callback) ->
    @db.query "SELECT * FROM barns WHERE listed_by = ?", [id],(error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models

  @pending = (callback) ->
    @db.query "SELECT * FROM barns WHERE approved = false", (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models