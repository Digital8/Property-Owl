async = require 'async'

# models = advertiser: system.load.model 'advertiser'

table = "po_advertisements"

exports.all = (callback) =>
  @db.query "SELECT * FROM #{table}", (error, results) =>
    for result in results
      result.visible = if result.visible then 'yes' else 'no'
    
    async.forEach results, (result, callback) =>
      Advertiser = require './advertiser'
      
      Advertiser.find result.advertiser_id, (error, results) =>
        # console.dir arguments
        result.advertiser = if results.length is 0 then '' else results.pop()
        # console.dir result
        do callback
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
    start: new Date
    stop: new Date
    updated_at: new Date
    created_at: new Date
  
  @db.query "UPDATE #{table} SET ? WHERE advertisement_id = ?", [map, ad.id], callback

exports.find = (id, callback) =>
  @db.query "SELECT * FROM #{table} WHERE advertisement_id = ?", [id], callback

exports.delete = (id, callback) =>
  @db.query "DELETE FROM #{table} WHERE advertisement_id = ?", [id], callback

exports.countActive = (callback) =>
  @db.query "SELECT COUNT(*) FROM #{table} WHERE NOW() BETWEEN start AND stop", (error, result) =>
    callback null, result[0]['COUNT(*)']

exports.random = (url, pos, callback) =>
  @db.query "SELECT * FROM #{table} AS adv INNER JOIN po_pages AS P ON adv.page_id = P.page_id INNER JOIN po_adspaces AS adsp ON adv.adspace_id = adsp.adspace_id WHERE P.url LIKE ? AND adsp.name = ? ORDER BY RAND() ", [url, pos], callback