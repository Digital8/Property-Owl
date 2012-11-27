async = require 'async'

{db} = system = require '../system'

models =
  advertiser: system.load.model 'advertiser'

table = "#{db.prefix}advertisements"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", (error, results) ->
    for result in results
      result.visible = if result.visible then 'yes' else 'no'
    
    async.forEach results, (result, callback) ->
      models.advertiser.find result.advertiser_id, (error, results) ->
        console.dir arguments
        result.advertiser = results.pop()
        console.dir result
        do callback
    , (error) ->
      callback error, results

exports.create = (ad, callback) ->
  db.query """INSERT INTO #{table} (description, page_id, advertiser_id, adspace_id, image_id, hyperlink, visible, start, stop) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)""", [ad.description, ad.page_id, ad.advertiser_id, ad.adspace_id, ad.image_id, ad.hyperlink, ad.visible, ad.start, ad.stop], callback

exports.update = (ad, callback) ->
  db.query "UPDATE #{table} SET description = ?, page_id = ?, advertiser_id = ?, adspace_id = ?, image_id = ?, hyperlink = ?, visible = ?, start = ?, stop = ? WHERE advertisement_id = ?", [ad.description, ad.page_id, ad.advertiser_id, ad.adspace_id, ad.image_id, ad.hyperlink, ad.visible, ad.start, ad.stop, ad.id], callback

exports.find = (id, callback) ->
  db.query "SELECT * FROM #{table} WHERE advertisement_id = ?", [id], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM #{table} WHERE advertisement_id = ?", [id], callback

exports.countActive = (callback) ->
  db.query "SELECT COUNT(*) FROM #{table} WHERE NOW() BETWEEN start AND stop", (error, result) ->
    callback null, result[0]['COUNT(*)']

exports.random = (callback) ->
  db.query "SELECT * FROM #{table} ORDER BY RAND()", (error, results) ->
    callback null, results.pop()