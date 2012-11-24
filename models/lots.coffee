###
 * Lots Model
 *
 * Handles all queries and actions to the database for the lots for the barn deals
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getLotsByPropertyId = (lot_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}lots WHERE lot_id = ?", [lot_id], callback

exports.getLotsByPropertyId = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}lots WHERE property_id = ?", [property_id], callback