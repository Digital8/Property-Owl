{db} = require '../system'

exports.getLotsByPropertyId = (lot_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}lots WHERE lot_id = ?", [lot_id], callback

exports.getLotsByPropertyId = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}lots WHERE property_id = ?", [property_id], callback

exports.addLotToProperty = (property_id, vals, callback) ->
  db.query "INSERT INTO #{db.prefix}lots (property_id, bedrooms, bathrooms, carspaces, level, interior_size, exterior_size, aspect, floor_plan, price) VALUES(?,?,?,?,?,?,?,?,?,?)",[property_id, vals.bedrooms, vals.bathrooms, vals.carspaces, vals.level, vals.interior, vals.exterior, vals.aspect, vals.floorPlans, vals.price], callback