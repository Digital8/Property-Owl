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