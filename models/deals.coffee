###
 * Deals Model
 *
 * Handles all queries and actions to the database for the listed deals
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getAllDeals = (callback) ->
  db.query "SELECT * FROM #{db.prefix}deals", callback

exports.getDealsByUserId = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}deals WHERE created_by = ?", [id], callback

exports.getDealsByPropertyId = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}deals WHERE property_id = ?", [property_id], callback  

exports.addDeal = (deal, callback) ->
  db.query "INSERT INTO #{db.prefix}deals(type, property_id, created_by, value) VALUES(?,?,?,?)", [deal.type, deal.property_id, deal.created_by, deal.value], callback