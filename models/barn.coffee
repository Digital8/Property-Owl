async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

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
    super
  
  hydrate: (callback) ->
    async.parallel
      owls: (callback) =>
        Owl = system.models.owl
        
        Owl.inBarn @id, (error, owls) =>
          @owls = owls
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
  
  fullAddress: ->
    "#{@address}, #{@suburb}, #{@state.toUpperCase()}, #{@postcode}"
  
  upload: (req, callback) ->
    console.log 'filez', req
    
    async.series
      removeDeals: (callback) =>
        @constructor.db.query "DELETE FROM deals WHERE entity_id = ? AND type = 'barn'", @id, callback
      
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
            type: 'barn'
        
        deals.pop()
        
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