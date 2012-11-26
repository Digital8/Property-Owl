db = require('../system').db

table = "#{db.prefix}advertisements"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", (error, results) ->
    for result in results
      result.visible = if result.visible then 'yes' else 'no' 
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