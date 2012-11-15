###
 * Saved Deals Model
 *
 * Handles all queries and actions to the database for the saved deals
 *
 * @package   Property Owl
 * @author    Jeff Lynne <jeff@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getSavedDealsByUserId = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}saveddeals WHERE user_id = ? AND enabled = ?", [id, '1'], callback

exports.saveDeal = (deal_id, user_id, callback) ->
  #this prolly needs to have a check to make sure the deal doesn't already exist
  db.query "INSERT INTO #{db.prefix}saveddeals(deal_id, user_id) VALUES(?,?)", [deal_id, user_id], callback

exports.checkDeal = (deal_id, user_id, callback) ->
  #this prolly needs to have a check to make sure the deal doesn't already exist
  db.query "SELECT * FROM #{db.prefix}saveddeals WHERE deal_id = ? and user_id = ?", [deal_id, user_id], callback

exports.removeSavedDeal = (deal_id, user_id, callback) ->
  db.query "UPDATE #{db.prefix}saveddeals SET enabled = ? WHERE deal_id = ? AND user_id = ?", ['0', deal_id, user_id], callback