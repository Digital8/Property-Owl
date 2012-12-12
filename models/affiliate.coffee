_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Affiliate extends Model
  @table = new Table
    name: 'affiliates'
    key: 'affiliate_id'
  
  @field 'name'
  @field 'company'
  @field 'logo'
  @field 'phone'
  @field 'address'
  @field 'suburb'
  @field 'suburb'
  @field 'state'
  @field 'email'
  @field 'postcode'
  @field 'visible'
  @field 'description'
  @field 'created_at'
  @field 'affiliate_category_id'

  constructor: (args = {}) ->
    super

  hydrate: (callback) ->
    async.series
      affiliateCategory: (callback) =>
        AffiliateCategory = system.models.affiliate_category
        
        AffiliateCategory.get @affiliate_category_id, (error, affiliateCategory) =>
          @category = affiliateCategory
          
          callback()
    
    , (error) => super callback
  
  upload: (req, callback) ->
    do callback
  
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