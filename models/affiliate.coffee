_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

Media = system.models.media

module.exports = class Affiliate extends Model
  @table = new Table
    name: 'affiliates'
    key: 'affiliate_id'

  @field 'name'
  @field 'logo'
  @field 'phone'
  @field 'address'
  @field 'suburb'
  @field 'state'
  @field 'email'
  @field 'postcode'
  @field 'visible', type: Boolean, default: yes
  @field 'description'
  @field 'created_at'
  
  @field 'category_id'

  constructor: (args = {}) ->
    super

  hydrate: (callback) ->
    async.series
      category: (callback) =>
        Category = system.models.category
        
        Category.get @category_id, (error, category) =>
          @category = category or {}
          
          callback()

      media: (callback) =>
        Media = system.models.media
        Media.for this, (error, medias) =>
          @images = medias
          #epix spam removal
          #console.log @images
          callback error
      
      enquiries: (callback) =>
        Enquiry = system.models.enquiry
        Enquiry.for this, (error, enquiries) =>
          @enquiries = enquiries
          callback error
    
    , (error) => super callback
  
  upload: (req, callback) ->
    return callback null unless req.files? and (Object.keys req.files).length
    
    async.forEach (Object.keys req.files), (key, callback) =>
      file = req.files[key]
      
      if file.size <= 0 then return callback null
      
      Media.upload
        entity_id: @id
        owner_id: req.session.user_id
        file: file
        type: 'affiliate'
      , (error, media) ->
        callback error, media
    
    , callback
    
  imageURL: ->
    if @images.length
      return '/uploads/' + @images.pop().filename
    else
      return '/images/placeholder.png' # or whatever it is

  @byCategory = (category_id, callback) ->
    @db.query "SELECT * FROM affiliates WHERE visible AND category_id = ?", [category_id], (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Affiliate row
        models.push model
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models

  @published = (callback) ->
    @db.query "SELECT * FROM affiliates WHERE visible", (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Affiliate row
        models.push model
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models