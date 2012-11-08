###
 * Media Model
 *
 * Handles all queries and actions to the database for the uploaded media
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getMediaByPropertyId = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}media WHERE property_id = ?", [property_id], callback

exports.addMedia = (mediaInfo, callback) ->
  db.query "INSERT INTO #{db.prefix}media(property_id, owner_id, filename, description, image) VALUES(?,?,?,?,?)", [mediaInfo.property_id, mediaInfo.owner_id, mediaInfo.filename, mediaInfo.description, mediaInfo.image], callback
  
exports.getImagesByPropertyId = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}media WHERE image = true AND property_id = ?", [property_id], callback