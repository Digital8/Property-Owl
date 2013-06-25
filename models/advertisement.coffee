async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Advertisement extends Model
  
  @table = new Table
    name: 'advertisements'
    key: 'advertisement_id'
  
  @has (-> Media), key: 'image', cardinality: 1
  
  @field 'description', type: String, required: yes
  @field 'advertiser_id'
  @field 'adspace_id'
  # @field 'image_id'
  @field 'hyperlink', type: String, required: yes
  @field 'visible', type: Boolean, default: on
  @field 'start', type: Date
  @field 'stop', type: Date
  @field 'created_at'
  @field 'updated_at'
  
  constructor: (args = {}) ->
    
    @_image = null
    Object.defineProperty this, 'image',
      get: =>
        return @_image if @_image
        if @image_id
          return {
            url: "https://propertyowl.s3.amazonaws.com/#{@image_id}"
            thumbnail: "https://propertyowl.s3.amazonaws.com/#{@image_id}"
          }
      set: (value) => @_image = value
    
    super
  
  hydrate: (callback) ->
    
    async.parallel
      
      advertiser: (callback) =>
        Advertiser.get @advertiser_id, (error, advertiser) =>
          @advertiser = advertiser
          callback error
      
      pages: (callback) =>
        @constructor.db.query """
        SELECT *
        FROM advertisement_page
        INNER JOIN pages ON advertisement_page.page_id = pages.page_id
        WHERE advertisement_page.advertisement_id = ?
        """, [@id], (error, pages) =>
          @pages = pages
          callback error
    
    , (error) =>
      
      super callback
  
  @countActive = (callback) =>
    
    @db.query """
    SELECT COUNT(*)
    FROM advertisements
    WHERE
      (
        (start and stop and (NOW() between start and stop))
          OR
        (NOT start and NOT stop)
      )
        AND
      visible
    """, (error, result) =>
      
      callback null, result[0]['COUNT(*)']
  
  @random = (page, adspace, callback) =>
    
    @db.query """
    SELECT *
    FROM advertisements
    WHERE
      (
        (start and stop and (NOW() between start and stop))
        OR
        (NOT start and NOT stop)
      )
        AND
      visible
        AND
      adspace_id = ?
        AND
      advertisement_id IN (
        SELECT DISTINCT advertisement_id
        FROM advertisement_page
        WHERE
          page_id = ?
      )
    ORDER BY RAND()
    LIMIT 1
    """, [adspace.id, page.id], (error, rows) =>
      
      return callback error if error?
      
      return callback null unless rows.length
      
      @new rows[0], callback

# exports.update = (ad, callback) =>

#   map =
#     description: ad.description
#     page_id: ad.page_id
#     advertiser_id: ad.advertiser_id
#     adspace_id: ad.adspace_id
#     image_id: ad.image_id
#     hyperlink: ad.hyperlink
#     visible: ad.visible
#     updated_at: new Date
  
#   for key in ['start', 'stop']
    
#     if ad[key] is ''
#       map[key] = '0000-00-00 00:00:00'
    
#     if ad[key] isnt ''
#       map[key] = ad[key]
  
#   @db.query "UPDATE #{table} SET ? WHERE advertisement_id = ?", [map, ad.id], (error) =>
    
#     return callback error if error?
    
#     @db.query "DELETE FROM po_advertisement_page WHERE advertisement_id = ?", [ad.id], (error) =>
      
#       return callback null unless ad.page_ids?
      
#       unless _.isArray ad.page_ids
#         ad.page_ids = [ad.page_ids]
      
#       async.map ad.page_ids, (page_id, callback) =>
        
#         record =
#           advertisement_id: ad.id
#           page_id: page_id
        
#         @db.query "INSERT INTO po_advertisement_page SET ?", record, callback
      
#       , callback