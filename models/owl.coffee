_ = require 'underscore'
_s = require 'underscore.string'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

Deal = system.models.deal
Media = system.models.media
Bookmark = system.models.bookmark

module.exports = class Owl extends Model
  @table = new Table
    name: 'owls'
    key: 'owl_id'
  
  @field 'barn_id', null: yes
  
  @field 'approved', type: Boolean, default: no
  
  @field 'approved_at', type: Date
  
  @field 'title'
  @field 'address'
  @field 'suburb'
  @field 'postcode'
  @field 'state'
  @field 'description'
  @field 'price'
  @field 'level'
  @field 'bedrooms'
  @field 'bathrooms'
  @field 'cars'
  @field 'internal_area'
  @field 'external_area'
  
  @field 'indoor_features'
  @field 'outdoor_features'
  @field 'other_features'
  @field 'aspect'
  
  @field 'development_type_id'
  
  @field 'development_status_id'
  
  @field 'feature_image'
  
  constructor: (args = {}) ->
    Object.defineProperty this, 'code', get: => _s.pad @id.toString(), 5, '0'
    
    super
  
  hydrate: (callback) ->
    async.series
      developmentType: (callback) =>
        DevelopmentType = system.models.development_type
        
        DevelopmentType.get @development_type_id, (error, developmentType) =>
          @developmentType = developmentType
          
          callback()
      
      developmentStatus: (callback) =>
        DevelopmentStatus = system.models.development_status
        
        DevelopmentStatus.get @development_status_id, (error, developmentStatus) =>
          @developmentStatus = developmentStatus
          
          callback()
      
      images: (callback) =>
        Media = system.models.media

        Media.forEntityWithClass this, klass: 'image', (error, medias) =>
          @images = medias
          
          if @feature_image? and @images.length
            
            feature_id = parseInt @feature_image
            
            feature_image = _.detect @images, (image) -> image.id is feature_id
            
            @images = _.filter @images, (image) -> image.id isnt feature_id
            
            @images.unshift feature_image
            
            @images = _.filter @images, (image) -> image?
          
          callback error
      
      files: (callback) =>
        Media = system.models.media

        Media.forEntityWithClass this, klass: 'file', (error, medias) =>
          @files = medias
          callback error
      
      deals: (callback) =>
        Deal.for this, (error, deals) =>
          @deals = deals
          callback error
      
      value: (callback) =>
        @value = 0
        
        for deal in @deals
          @value += deal.value
          
        if @value > 0
          @value = Math.floor(100 * @value / @price)
        
        callback()
        
      registrations: (callback) =>
        system.db.query "SELECT * FROM po_registrations AS R INNER JOIN po_users AS U ON R.user_id = U.user_id where R.type = 'owl' and R.resource_id = ?", [@id], (err, results) =>
          @registrations = results
        
          callback()
      
      enquiries: (callback) =>
        
        system.db.query "SELECT * FROM enquiries AS E INNER JOIN po_users AS U ON E.user_id = U.user_id where E.entity_type = 'owl' and E.entity_id = ?", [@id], (err, results) =>
          @enquiries = results
          callback()

      features: (callback) =>
        expose = (type) =>
          @["#{type}Features"] = []
          # if @["#{type}_features"] and @["#{type}_features"].length
          # return unless @["#{type}_features"].length
          if @["#{type}_features"]?
            @["#{type}Features"] = @["#{type}_features"].split '\n'
        
        expose 'outdoor'
        expose 'indoor'
        expose 'other'
        
        callback()
      
      barns: (callback) =>
        return do callback unless @barn_id?
        
        Barn = system.models.barn
        
        Barn.dry @barn_id, (error, barn) =>
          @barn = barn
          do callback
      
      user: (callback) =>
        system.models.user.getUserById @user_id, (error, [user]) =>
          return callback error if error?
          @user = user
          do callback
    
    , (error) => super callback
  
  hydrateForUser: (user, callback) ->
    Bookmark.forUserAndDeal user, this, (error, bookmark) =>
      return callback error if error?
      
      @bookmark = bookmark
      
      do callback
  
  heroImageURL: ->
    unless @images? and @images.length then return '/images/placeholder.png'
    
    # find the hero
    hero = _.find @images, (image) =>
      return Number(image.id) is Number(@feature_image)
    
    # console.log owl: @, hero: hero
    
    # default to latest image
    hero ?= @images.pop()
    
    return "/uploads/#{hero.filename}"
  
  fullAddress: ->
    "#{@address}, #{@suburb}, #{@state.toUpperCase()}, #{@postcode}"
  
  displayTitle: ->
    "#{@address}, #{@suburb}, #{@state.toUpperCase()}"
  
  deals: (callback) ->
    @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
      return callback error if error
      
      callback null

  upload: (req, callback) ->
    
    # process(Req, String, Function)
    # creates Media for each filea req's uploads
    # takes
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
          type: 'owl'
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
  
  @change =
    approved: ({values, model}) ->
      if values.new is yes and values.old is no
        
        model.constructor.patch model.id, approved_at: new Date, ->
      
      if values.new is no and values.old is yes
        
        model.constructor.patch model.id, approved_at: 0, ->
  
  @inBarn = (barnId, callback) =>
    @db.query "SELECT * FROM #{@table.name} WHERE barn_id = ?", [barnId], (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models
  
  @state = (state, callback) ->
    @db.query """
      SELECT *
      FROM #{@table.name}
      WHERE
          state = ?
        AND
          approved
      ORDER BY created_at ASC
    """, [state], (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models
  
  @top = (callback) ->
    @db.query """
    SELECT
      *,
      discount / price AS ratio
      FROM (
        SELECT
        *,
        (
          SELECT SUM(value)
           FROM deals
           WHERE owl_id = OWLS.owl_id
        ) AS discount
    FROM owls AS OWLS
    WHERE
      approved
    HAVING discount) AS TEMP
    ORDER BY ratio DESC
    LIMIT 1
    """, [], (error, rows) ->
      return callback error if error
      
      owl = new Owl rows[0]
      
      owl.hydrate ->
        
        callback null, owl
        
  @topstate = (state, callback) ->
    @db.query """
    SELECT
      *,
      discount / price AS ratio
      FROM (
        SELECT
        *,
        (
          SELECT SUM(value)
           FROM deals
           WHERE owl_id = OWLS.owl_id
        ) AS discount
    FROM owls AS OWLS
    WHERE
      approved
      AND
      state = ?
    HAVING discount) AS TEMP
    ORDER BY ratio DESC
    LIMIT 1
    """, [state], (error, rows) ->
      return callback error if error
      
      owl = new Owl rows[0]
      
      owl.hydrate ->
        callback null, owl
  
  @byDeveloper = (id, callback) ->
    @db.query "SELECT * FROM owls WHERE listed_by = ?", [id] ,(error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models

  @pending = (callback) ->
    @db.query "SELECT * FROM owls WHERE approved = false", (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models
  
  @search: (q, callback) ->
    console.log 'search', q
    
    query = """
      SELECT *
      FROM owls
      WHERE
        #{q.suburbQuery}
        #{q.stateQuery}
        #{q.developmentTypeQuery}
        #{q.developmentStatusQuery}
        price >= ?
        AND
        price <= ?
        AND
        bedrooms >= ?
        AND
        bedrooms <= ?
        AND
        bathrooms >= ?
        AND
        cars >= ?
      GROUP BY owl_id
    """
    
    console.log query
    
    args = [
      q.minPrice
      q.maxPrice
      q.minBeds
      q.maxBeds
      q.bathrooms
      q.cars
    ]
    
    console.log args
    
    @db.query query, args, (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models