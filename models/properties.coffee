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

exports.getAllPropertiesById = (id, callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE P.property_id = ?",[id], callback

exports.getAllPropertiesByState = (state, callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE P.state = ?",[state], callback

exports.getPropertyTypes = (callback) ->
  db.query "SELECT PT.* FROM #{db.prefix}property_types AS PT", callback

exports.addProperty = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}properties(title, address, state, development_stage, description, property_type_id, price, listed_by, created_at) VALUES(?,?,?,?,?,?,?, NOW())", [vals.title, vals.address, vals.state, vals.development_stage, vals.description, vals.ptype, vals.price, vals.developer], callback

exports.getPropertyByUserId = (user_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}properties AS P RIGHT JOIN #{db.prefix}users AS U ON p.listed_by = U.user_id WHERE listed_by = ?", [user_id], callback

exports.updateProperty = (values, callback) ->
  db.query "UPDATE #{db.prefix}properties SET bedrooms = ?, bathrooms = ?, cars = ?, internal_area = ?, external_area = ?", [values.bedrooms, values.bathrooms, values.cars, values.internal_area, values.external_area], callback