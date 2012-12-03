_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

Media = system.models.media
Deal = system.models.deal

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
  # @field 'feature_image'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    async.parallel
      developmentType: (callback) =>
        DevelopmentType = system.models.development_type
        
        DevelopmentType.get @development_type_id, (error, developmentType) =>
          @type = developmentType
          
          callback()
      
      media: (callback) =>
        Media.all (error, medias) =>
          console.log medias
          # console.log 'medias', medias
          
          @images = []
          
          # @images = _.filter medias, (media) => media.entity_id = @id
          
          for media in medias
            @images.push media if media.entity_id is @id
          
          callback()
      
      deals: (callback) =>
        Deal.all (error, deals) =>
          console.log deals
          # console.log 'medias', medias
          
          @deals = []
          
          # @images = _.filter medias, (media) => media.entity_id = @id
          
          for deal in deals
            @deals.push deal if deal.owl_id is @id
          
          callback()
    
    , (error) => super callback
  
  deals: (callback) ->
    @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
      return callback error if error
      
      callback null
  
  upload: (req, callback) ->
    if req.files? and (Object.keys req.files).length
      async.forEach (Object.keys req.files), (key, callback) =>
        file = req.files[key]
        
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