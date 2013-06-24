_ = require 'underscore'
_s = require 'underscore.string'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Owl extends Model
  
  @table = new Table
    name: 'owls'
    key: 'owl_id'
  
  @has (-> Media), cardinality: Infinity, key: 'images', tag: 'image'
  @has (-> Media), cardinality: Infinity, key: 'files', tag: 'file'
  
  @field 'barn_id', null: yes
  
  @field 'approved', type: Boolean, default: no
  
  @field 'approved_at', type: Date
  
  @field 'title', type: String, required: yes
  @field 'address', type: String, required: yes
  @field 'suburb', type: String, required: yes
  @field 'postcode', type: String, required: yes
  @field 'state', type: String, required: yes
  @field 'description', type: String, required: yes
  @field 'price', type: Number, required: yes
  @field 'level', type: Number, required: yes
  @field 'bedrooms', type: Number, required: yes
  @field 'bathrooms', type: Number, required: yes
  @field 'cars', type: Number, required: yes
  @field 'internal_area'
  @field 'external_area'
  
  @field 'listed_by'
  
  @field 'indoor_features'
  @field 'outdoor_features'
  @field 'other_features'
  @field 'aspect'
  
  @field 'development_type_id'
  @field 'development_status_id'
  
  @field 'feature_image'
  
  constructor: (args = {}) ->
    
    Object.defineProperty this, 'code',
      get: => _s.pad @id.toString(), 5, '0'
    
    Object.defineProperty this, 'unit',
      get: =>
        {address} = this
        address.replace '\\', '/'
        address = address.split '/'
        if address.length > 1
          return address[0].trim()
        else
          return
    
    Object.defineProperty this, 'url',
      get: => "/owls/#{@id}"
    
    Object.defineProperty this, 'fullAddress', get: =>
      (_.compact [@address, @suburb, @state.toUpperCase(), @postcode]).join ', '
    
    super
  
  hydrate: (callback) ->
    
    async.series
      developmentType: (callback) =>
        DevelopmentType.get @development_type_id, (error, developmentType) =>
          @developmentType = developmentType
          callback()
      
      developmentStatus: (callback) =>
        DevelopmentStatus.get @development_status_id, (error, developmentStatus) =>
          @developmentStatus = developmentStatus
          callback()
      
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
        @constructor.db.query """
        SELECT * FROM registrations AS R
        INNER JOIN users AS U ON R.user_id = U.user_id
        WHERE
          R.entity_type = 'owl'
        AND
          R.entity_id = ?
        """, [@id], (err, results) =>
          @registrations = results
          callback()
      
      enquiries: (callback) =>
        
        @constructor.db.query """
        SELECT * FROM enquiries AS E
        INNER JOIN users AS U ON E.user_id = U.user_id
        WHERE
          E.entity_type = 'owl'
        AND
          E.entity_id = ?
        """, [@id], (err, results) =>
          @enquiries = results
          callback()
      
      features: (callback) =>
        expose = (type) =>
          @["#{type}Features"] = []
          if @["#{type}_features"]?
            @["#{type}Features"] = @["#{type}_features"].split '\n'
        
        expose 'outdoor'
        expose 'indoor'
        expose 'other'
        
        callback()
      
      barns: (callback) =>
        return do callback unless @barn_id?
        
        Barn.dry @barn_id, (error, barn) =>
          @barn = barn
          do callback
      
      user: (callback) =>
        User.get @listed_by, (error, user) =>
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
    
    if @feature_image != ''
      return "/uploads/#{@feature_image}"
    else
      # default to latest image
      # # find the hero
      hero = _.find @images, (image) => return Number(image.filename) is Number(@feature_image)
      
      hero ?= @images.pop()
      
      return "/uploads/#{hero.filename}"
  
  displayTitleShort: ->
    shortAddress = _s.prune @address, 16
    "#{shortAddress}, #{@suburb}, #{@state.toUpperCase()}"
  
  displayTitle: ->
    "#{@address}, #{@suburb}, #{@state.toUpperCase()}"

  deals: (callback) ->
    
    @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
      
      return callback error if error
      
      callback null
  
  @change =
    approved: ({values, model}) ->
      if values.new is yes and values.old is no
        
        model.constructor.patch model.id, approved_at: new Date, ->
      
      if values.new is no and values.old is yes
        
        model.constructor.patch model.id, approved_at: 0, ->
  
  @inBarn = (id, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE barn_id = ?", [id], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
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
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
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
    """, [], (error, rows) =>
      
      return callback error if error?
      
      @new rows[0], callback
  
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
    """, [state], (error, rows) =>
      
      return callback error if error?
      
      @new rows[0], callback
  
  @byDeveloper = (id, callback) ->
    
    @db.query "SELECT * FROM owls WHERE listed_by = ?", [id] ,(error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback

  @pending = (callback) ->
    
    @db.query "SELECT * FROM owls WHERE approved = false", (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  @search: (q, callback) ->
    
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
    
    args = [
      q.minPrice
      q.maxPrice
      q.minBeds
      q.maxBeds
      q.bathrooms
      q.cars
    ]
    
    @db.query query, args, (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback