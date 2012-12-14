_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class News extends Model
  @table = new Table
    name: 'news'
    key: 'news_id'
  
  @field 'title'
  @field 'content'
  @field 'created_at'
  @field 'type'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    super callback
  
  upload: (req, callback) ->
    do callback
  
  # @published = (callback) ->
  #   @db.query "SELECT * FROM affiliates WHERE visible", (error, rows) =>
  #     return callback error if error
      
  #     models = []
      
  #     for row in rows
  #       model = new Affiliate row
  #       models.push model
      
  #     async.forEach models, (model, callback) =>
  #       model.hydrate callback
  #     , (error) ->
  #       callback null, models