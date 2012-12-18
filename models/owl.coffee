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
  
  @field 'barn_id'
  
  @field 'title'
  @field 'address'
  @field 'suburb'
  @field 'postcode'
  @field 'state'
  @field 'description'
  @field 'price'
  @field 'bedrooms'
  @field 'bathrooms'
  @field 'cars'
  @field 'internal_area'
  @field 'external_area'
  # @field 'approved'
  # ,
  #   default: 0
  #   parse: ->
  
  @field 'indoor_features'
  @field 'outdoor_features'
  @field 'other_features'
  
  @field 'development_type_id'
  
  #@field 'feature_image'
  
  constructor: (args = {}) ->
    Object.defineProperty this, 'code', get: => _s.pad @id.toString(), 5, '0'
    
    super
  
  hydrate: (callback) ->
    async.series
      developmentType: (callback) =>
        DevelopmentType = system.models.development_type
        
        DevelopmentType.get @development_type_id, (error, developmentType) =>
          @type = developmentType
          
          callback()
      
      media: (callback) =>
        Media = system.models.media
        Media.for this, (error, medias) =>
          @images = medias
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
        system.db.query "SELECT Count(*) as registrations FROM po_registrations where type = 'owl' and resource_id = ?", [@id], (err, results) =>
          @registrations = results.pop().registrations
        
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
  
  deals: (callback) ->
    @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
      return callback error if error
      
      callback null
  

  @search: (v, callback) ->
    @db.query "SELECT P.* FROM owls AS P INNER JOIN development_types AS PT WHERE state LIKE ? AND PT.name LIKE ? AND price >= ? AND price <= ? AND bathrooms >= ? AND cars >= ? AND development_stage LIKE ? AND suburb LIKE ? GROUP BY P.owl_id", [v.state, v.pType, v.minPrice, v.maxPrice, v.bathrooms, v.cars, v.devStage, v.suburb], callback

  upload: (req, callback) ->
    
    async.series
      removeDeals: (callback) =>
        @constructor.db.query "DELETE FROM deals WHERE entity_id = ? AND type = 'owl'", @id, callback
      
      addDeals: (callback) =>
        values = req.body.value.pop()
        names = req.body.name.pop()
        types = req.body.type.pop()
        
        deals = []
        
        return callback() unless types
        
        for index in [0...types.length]
          deals.push
            entity_id: @id
            deal_type_id: types[index]
            description: names[index]
            value: values[index]
            created_by: req.session.user_id
            type: 'owl'
        
        deals.pop()
        
        
        async.forEach deals, (deal, callback) =>
          @constructor.db.query "INSERT INTO deals SET ?", deal, callback
        , callback
    
    , (error) =>
      if req.files? and (Object.keys req.files).length
        async.forEach (Object.keys req.files), (key, callback) =>
          file = req.files[key]
          
          if file.size <= 0 then return callback null
          
          Media.upload
            entity_id: @id
            owner_id: req.session.user_id
            file: file
            type: 'owl'
          , (error, media) ->
            callback error, media
        
        , callback
      
      else
        
        callback()
  
  @inBarn = (barnId, callback) =>
    @db.query "SELECT * FROM #{@table.name} WHERE barn_id = ?", [barnId], (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models
  
  @state = (state, callback) ->
    
    
    @db.query "SELECT * FROM #{@table.name} WHERE state = ? ORDER BY created_at ASC", [state], (error, rows) =>
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
    WHERE approved
    HAVING discount) AS TEMP
    ORDER BY ratio DESC
    LIMIT 1
    """, (error, rows) ->
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
    WHERE state = ? AND approved
    HAVING discount) AS TEMP
    ORDER BY ratio DESC
    LIMIT 1
    """, [state], (error, rows) ->
      return callback error if error
      
      owl = new Owl rows[0]
      
      owl.hydrate ->
        callback null, owl
  
  @pending = (callback) ->
    @db.query "SELECT * FROM owls WHERE approved = false", (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models
