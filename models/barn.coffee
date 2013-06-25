async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Barn extends Model
  
  @table = new Table
    name: 'barns'
    key: 'barn_id'
  
  @has (-> Media), cardinality: Infinity, key: 'images', tag: 'image'
  @has (-> Media), cardinality: Infinity, key: 'files', tag: 'file'
  
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
  
  @field 'feature_image_id'
  
  @field 'approved', type: Boolean, default: no
  
  constructor: (args = {}) ->
    
    Object.defineProperty this, 'code',
      get: => _s.pad @id.toString(), 5, '0'
    
    Object.defineProperty this, 'url',
      get: => "/barns/#{@id}"
    
    Object.defineProperty this, 'fullAddress', get: =>
      (_.compact [@address, @suburb, @state.toUpperCase(), @postcode]).join ', '
    
    Object.defineProperty this, 'feature_image', get: =>
      for image in @images
        return image if image.id is @feature_image_id
      if @images[0]?
        return @images[0]
      return {
        id: 0
        url: '/uploads/placeholder.png'
        thumbnail: '/uploads/placeholder.png'
      }
    
    super
  
  hydrate: (callback) ->
    
    async.parallel
      
      owls: (callback) =>
        Owl.inBarn @id, (error, owls) =>
          @owls = owls
          do @tagOwls
          callback error
      
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
    
    , (error) => super callback
  
  hydrateForUser: (user, callback) ->
    Bookmark.forUserAndDeal user, this, (error, bookmark) =>
      return callback error if error?
      @bookmark = bookmark
      do callback
  
  tagOwls: ->
    for owl, index in @owls
      owl.index = index
      owl.alpha = 'ABCDE'[index]
  
  
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
        
