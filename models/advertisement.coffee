async = require 'async'
_ = require 'underscore'

# models = advertiser: system.load.model 'advertiser'

table = "po_advertisements"

exports.all = (callback) =>
  @db.query "SELECT * FROM #{table}", (error, results) =>
    
    for result in results
      result.visible = if result.visible then 'yes' else 'no'
    
    async.forEach results, (result, callback) =>
      Advertiser = require './advertiser'
      
      Advertiser.find result.advertiser_id, (error, results) =>
        result.advertiser = if results.length is 0 then '' else results.pop()
        do callback
    , (error) =>
      
      async.map results, (ad, callback) =>
        
        @db.query """
        SELECT *
        FROM po_advertisement_page
        INNER JOIN po_pages ON po_advertisement_page.page_id = po_pages.page_id
        WHERE po_advertisement_page.advertisement_id = ?
        """, [ad.advertisement_id], (error, pages) =>
          
          return callback error if error?
          
          ad.pages = pages
          
          callback null
        
      , (error) =>
        
        callback error, results

exports.create = (ad, callback) =>
  
  @db.query """INSERT INTO #{table} (description, page_id, advertiser_id, adspace_id, image_id, hyperlink, visible, start, stop) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)""", [ad.description, ad.page_id, ad.advertiser_id, ad.adspace_id, ad.image_id, ad.hyperlink, ad.visible, ad.start, ad.stop], callback

exports.update = (ad, callback) =>
  
  map =
    description: ad.description
    page_id: ad.page_id
    advertiser_id: ad.advertiser_id
    adspace_id: ad.adspace_id
    image_id: ad.image_id
    hyperlink: ad.hyperlink
    visible: ad.visible
    updated_at: new Date
  
  for key in ['start', 'stop']
    
    if ad[key] is ''
      map[key] = '0000-00-00 00:00:00'
    
    if ad[key] isnt ''
      map[key] = ad[key]
  
  @db.query "UPDATE #{table} SET ? WHERE advertisement_id = ?", [map, ad.id], (error) =>
    
    return callback error if error?
    
    @db.query "DELETE FROM po_advertisement_page WHERE advertisement_id = ?", [ad.id], (error) =>
      
      return callback null unless ad.page_ids?
      
      async.map ad.page_ids, (page_id, callback) =>
        
        record =
          advertisement_id: ad.id
          page_id: page_id
        
        @db.query "INSERT INTO po_advertisement_page SET ?", record, callback
      
      , callback

exports.find = (id, callback) =>
  
  @db.query "SELECT * FROM #{table} WHERE advertisement_id = ?", [id], (error, advertisements) =>
    
    return callback error if error?
    
    async.map advertisements, (advertisement, callback) =>
      
      @db.query "SELECT * FROM po_advertisement_page WHERE advertisement_id = ?", [advertisement.advertisement_id], (error, pages) =>
        
        advertisement.page_ids = _.pluck pages, 'page_id'
        
        callback null
    
    , (error) =>
      
      console.log advertisements
      
      callback error, advertisements

exports.delete = (id, callback) =>
  
  @db.query "DELETE FROM #{table} WHERE advertisement_id = ?", [id], callback

exports.countActive = (callback) =>
  
  @db.query """
  SELECT COUNT(*)
  FROM po_advertisements
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

exports.random = (url, pos, callback) =>
  
  # page
  @db.query "SELECT * FROM po_pages WHERE url LIKE ?", [url], (error, pages) =>
    
    [page] = pages
    
    return callback null unless page?
    
    # space
    @db.query "SELECT * FROM po_adspaces WHERE name LIKE ?", [pos], (error, spaces) =>
      
      [space] = spaces
      
      return callback null unless space?
      
      @db.query """
      SELECT *
      FROM po_advertisements
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
          FROM po_advertisement_page
          WHERE
            page_id = ?
        )
      ORDER BY RAND()
      """, [space.adspace_id, page.page_id], (error, advertisements) =>
        
        callback null, advertisements