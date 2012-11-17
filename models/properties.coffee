###
 * Properties Model
 *
 * Handles all queries and actions to the database for the listed properties
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getAllProperties = (callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id", callback

exports.getAllPropertiesById = (id, callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE P.property_id = ?",[id], callback

exports.getAllPropertiesByState = (state, callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE P.state = ?",[state], callback

exports.getPropertyTypes = (callback) ->
  db.query "SELECT PT.* FROM #{db.prefix}property_types AS PT", callback

exports.getPropertiesByDealType = (dealType, includeAllCategory, callback) ->
  if includeAllCategory != true
    db.query "SELECT * FROM #{db.prefix}properties AS P WHERE p.deal_type = ? ", [dealType] ,callback
  else
    db.query "SELECT * FROM #{db.prefix}properties AS P WHERE p.deal_type = ? OR p.deal_type = 'all'", [dealType] ,callback

exports.addProperty = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}properties(title, address, suburb, state, development_stage, description, property_type_id, price, deal_type, listed_by, created_at) VALUES(?,?,?,?,?,?,?,?,?,?, NOW())", [vals.title, vals.address, vals.suburb, vals.state, vals.development_stage, vals.description, vals.ptype, vals.price, vals.deal_type, vals.developer], callback

exports.getPropertiesOfBarnDeal = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}properties AS P WHERE P.deal_of = ?", [property_id], callback

exports.getPropertyByUserId = (user_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}properties AS P RIGHT JOIN #{db.prefix}users AS U ON p.listed_by = U.user_id WHERE listed_by = ?", [user_id], callback

exports.updateProperty = (values, callback) ->
  db.query "UPDATE #{db.prefix}properties SET bedrooms = ?, bathrooms = ?, cars = ?, internal_area = ?, external_area = ?", [values.bedrooms, values.bathrooms, values.cars, values.internal_area, values.external_area], callback

exports.removeBarnDeal = (property_id, callback) ->
  db.query "UPDATE #{db.prefix}properties SET deal_of = 0 WHERE property_id = ?", [property_id], callback