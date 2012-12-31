async = require 'async'
_s = require 'underscore.string'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

Deal = system.models.deal

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
  
  constructor: (args = {}) ->
    Object.defineProperty this, 'code', get: => _s.pad @id.toString(), 5, '0'
    
    super
  
  hydrate: (callback) ->
    async.parallel
      owls: (callback) =>
        Owl = system.models.owl
        
        Owl.inBarn @id, (error, owls) =>
          @owls = owls
          
          for owl, index in @owls
            owl.index = index
            owl.alpha = 'ABCDE'[index]
          
          callback error
      
      deals: (callback) =>
        Deal = system.models.deal
        Deal.for this, (error, deals) =>
          @deals = deals
          callback error
      
      user: (callback) =>
        system.db.query "SELECT * FROM po_users WHERE user_id = ?", [@listed_by], (error, rows) =>
          return callback 'no owner' unless rows?.length
          @user = rows.pop()
          do callback
    
    , (error) =>
      @user ?= {}
      callback error, this
      
  heroImageURL: ->
    unless @images? and @images.length then return '/images/placeholder.png'
    
    console.log @title
    
    # find the hero
    hero = _.find @images, (image) =>
      return Number(image.id) is Number(@feature_image)
    
    # console.log owl: @, hero: hero
    
    # default to latest image
    hero ?= @images.pop()
    
    return "/uploads/#{hero.filename}"

  fullAddress: ->
    "#{@address}, #{@suburb}, #{@state.toUpperCase()}, #{@postcode}"
  
  upload: (req, callback) ->
    console.log 'filez', req
    
    async.series
      removeDeals: (callback) =>
        @constructor.db.query "DELETE FROM deals WHERE entity_id = ? AND type = 'barn'", @id, callback
      
      addDeals: (callback) =>

        console.log req.body
        values = req.body.value
        names = req.body.name
        types = req.body.type
        
        deals = []

        return callback() unless types
        
        for index in [0...types.length]
          deals.push
            entity_id: @id
            deal_type_id: types[index]
            description: names[index]
            value: values[index]
            user_id: req.session.user_id
            type: 'barn'
        
        console.log deals
        
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
            type: 'barn'
          , (error, media) ->
            callback error, media
        
        , callback
      
      else
        console.log 'no uploads'
        
        callback()
  
  @pending = (callback) ->
    @db.query "SELECT * FROM barns WHERE approved = false", (error, rows) =>
      return callback error if error
      
      models = (new this row for row in rows)
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models