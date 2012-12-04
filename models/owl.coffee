_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

Deal = system.models.deal
Media = system.models.media

module.exports = class Owl extends Model
  @table = new Table
    name: 'owls'
    key: 'owl_id'
  
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
  
  @field 'development_type_id'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    async.series
      developmentType: (callback) =>
        DevelopmentType = system.models.development_type
        
        DevelopmentType.get @development_type_id, (error, developmentType) =>
          @type = developmentType
          
          callback()
      
      media: (callback) =>
        # console.log system.models
        
        Media = system.models.media
        Media.all (error, medias) =>
          # console.log medias
          # console.log 'medias', medias
          
          @images = []
          
          # @images = _.filter medias, (media) => media.entity_id = @id
          
          for media in medias
            @images.push media if media.entity_id is @id
          
          callback()
      
      deals: (callback) =>
        Deal.all (error, deals) =>
          # console.log deals
          # console.log 'medias', medias
          
          @deals = []
          
          # @images = _.filter medias, (media) => media.entity_id = @id
          
          for deal in deals
            @deals.push deal if deal.owl_id is @id
          
          callback()
      
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
    
    , (error) => super callback
  
  deals: (callback) ->
    @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
      return callback error if error
      
      callback null
  
  upload: (req, callback) ->
    console.log 'filez', req.files
    
    async.series
      removeDeals: (callback) =>
        @constructor.db.query "DELETE FROM deals WHERE owl_id = ?", @id, callback
      
      addDeals: (callback) =>
        values = req.body.value.pop()
        names = req.body.name.pop()
        types = req.body.type.pop()
        
        deals = []
        
        for index in [0...types.length]
          deals.push
            owl_id: @id
            deal_type_id: types[index]
            description: names[index]
            value: values[index]
            created_by: req.session.user_id
        
        deals.pop()
        
        console.log deals
        
        async.forEach deals, (deal, callback) =>
          @constructor.db.query "INSERT INTO deals SET ?", deal, callback
        , callback
    
    , (error) ->
      if req.files? and (Object.keys req.files).length
        async.forEach (Object.keys req.files), (key, callback) =>
          file = req.files[key]
          
          if file.size <= 0 then return callback null
          
          Media.upload
            entity_id: @id
            owner_id: req.session.user_id
            file: file
          , (error, media) ->
            callback error, media
        
        , callback
      
      else
        console.log 'no uploads'
        
        callback()
  
  @state = (state, callback) ->
    console.log state
    
    @db.query "SELECT * FROM #{@table.name} WHERE state = ? ORDER BY created_at ASC", [state], (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Owl row
        models.push model
      
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