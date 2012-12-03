{db} = require '../system'

exports.getSavedDealsByUserId = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}saveddeals AS SD INNER JOIN owls AS P ON SD.deal_id = P.owl_id WHERE SD.user_id = ? AND enabled = ?", [id, 1], callback

exports.saveDeal = (deal_id, user_id, callback) ->
  #this prolly needs to have a check to make sure the deal doesn't already exist
  db.query "INSERT INTO #{db.prefix}saveddeals(deal_id, user_id) VALUES(?, ?)", [deal_id, user_id], callback

exports.checkDeal = (deal_id, user_id, callback) ->
  #this prolly needs to have a check to make sure the deal doesn't already exist
  db.query "SELECT * FROM #{db.prefix}saveddeals WHERE deal_id = ? AND user_id = ? AND enabled = ?", [deal_id, user_id, 1], callback

exports.removeSavedDeal = (deal_id, user_id, callback) ->
  db.query "UPDATE #{db.prefix}saveddeals SET enabled = ? WHERE deal_id = ? AND user_id = ?", [0, deal_id, user_id], callback
