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
    # async.series
    #   affiliateCategory: (callback) =>
    #     AffiliateCategory = system.models.affiliate_category
        
    #     AffiliateCategory.get @affiliate_category_id, (error, affiliateCategory) =>
    #       @category = affiliateCategory
          
    #       callback()
    
    # , (error) => super callback
  
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

# {db} = require '../system'

# exports.getAllNews = (callback) ->
#   db.query "SELECT * FROM po_news AS N INNER JOIN po_users AS U on N.user_id = U.user_id ORDER BY N.posted_at DESC", callback

# exports.getAllNewsByType = (type, callback) ->
#   db.query "SELECT * FROM po_news AS N INNER JOIN po_users AS U on N.user_id = U.user_id WHERE N.news_type = ? ORDER BY N.posted_at DESC", [type], callback

# exports.getNewsById = (id, callback) ->
#   db.query "SELECT * FROM po_news AS N INNER JOIN po_users AS U on N.user_id = U.user_id WHERE N.news_id = ?", [id], callback

# exports.insert = (vals, callback) ->
#   db.query "INSERT INTO po_news (user_id, title, content) VALUES(?, ?, ?)", [vals.id, vals.title, vals.content], callback

# exports.update = (vals, callback) ->
#   db.query "UPDATE po_news SET title = ?, content = ? WHERE news_id = ?", [vals.title, vals.content, vals.id], callback

# exports.delete = (id, callback) ->
#   db.query "DELETE FROM po_news WHERE news_id = ?", [id], callback