async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Barn extends Model
  @table = new Table
    name: 'barns'
    key: 'barn_id'
  
  @field 'title'
  @field 'address'
  @field 'suburb'
  @field 'postcode'
  @field 'state'
  @field 'description'
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
      
      user: (callback) =>
        system.db.query "SELECT * FROM po_users WHERE user_id = ?", [@listed_by], (error, rows) =>
          # console.log 'FUCK', rows
          return callback 'no owner' unless rows?.length
          @user = rows.pop()
          do callback
    , (error) =>
      @user ?= {}
      callback error, this
  
  fullAddress: ->
    "#{@address}, #{@suburb}, #{@state.toUpperCase()}, #{@postcode}"
  
  @pending = (callback) ->
    @db.query "SELECT * FROM barns WHERE approved = false", (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Barn row
        models.push model
      
      async.forEach models, (model, callback) =>
        model.hydrate callback
      , (error) ->
        callback null, models