{db} = require '../system'

exports.getAllDeals = (callback) ->
  db.query "SELECT * FROM #{db.prefix}deals", callback

exports.getDealById = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}deals WHERE deal_id = ?", [id], callback

exports.getDealsByUserId = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}deals WHERE created_by = ?", [id], callback

exports.getDealsByPropertyId = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}deals WHERE property_id = ?", [property_id], callback  

exports.addDeal = (deal, callback) ->
  db.query "INSERT INTO #{db.prefix}deals(type, property_id, created_by, value) VALUES(?,?,?,?)", [deal.type, deal.property_id, deal.created_by, deal.value], callback

exports.deleteDealById = (id, callback) ->
  db.query "DELETE FROM #{db.prefix}deals WHERE deal_id = ?", [id], callback