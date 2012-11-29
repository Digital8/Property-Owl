async = require 'async'
_ = require 'underscore'

{db} = require '../system'

exports.getAllProperties = (callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id", callback

exports.getAllApprovedProperties = (callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE approved", callback

exports.getAllPropertiesById = (id, callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE P.property_id = ?",[id], callback

# TODO add wednesday condition to query
exports.getBestDeal = (callback) ->
  db.query "SELECT * FROM #{db.prefix}properties WHERE approved", (error, properties) ->
    async.map properties, (property, callback) ->
      db.query "SELECT * FROM #{db.prefix}deals WHERE property_id = #{property.property_id}", (error, deals) ->
        property.deals = deals
        callback null, property
    , (error, properties) ->
      for property in properties
        property.blah = 0
        
        for deal in property.deals
          property.blah += deal.value
        
        property.awesomeness = property.blah / property.price * 100

      bestdeal = _.max properties, (property) -> property.awesomeness
      callback null, bestdeal

exports.getBestStateDeals = (callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id", callback

exports.getAllPropertiesByState = (state, callback) ->
  db.query "SELECT P.*, PT.type AS property_type FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT ON P.property_type_id = PT.property_type_id WHERE P.state = ?",[state], callback

exports.getPropertyTypes = (callback) ->
  db.query "SELECT PT.* FROM #{db.prefix}property_types AS PT", callback

exports.getPropertiesByDealType = (dealType, includeAllCategory, callback) ->
  if includeAllCategory != true
    db.query "SELECT * FROM #{db.prefix}properties AS P WHERE P.deal_type = ? ", [dealType] ,callback
  else
    db.query "SELECT * FROM #{db.prefix}properties AS P WHERE P.deal_type = ? OR P.deal_type = 'all'", [dealType] ,callback

exports.addProperty = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}properties(title, address, suburb, postcode, state, development_stage, description, property_type_id, price, deal_type, listed_by, created_at) VALUES(?,?,?,?,?,?,?,?,?,?,?, NOW())", [vals.title, vals.address, vals.suburb, vals.postcode, vals.state, vals.development_stage, vals.description, vals.ptype, vals.price, vals.deal_type, vals.developer], callback

exports.updatePropertyDetails = (id, vals, callback) ->
  db.query "UPDATE #{db.prefix}properties SET title = ?, address = ?, suburb = ?, postcode = ?, state = ?, development_stage = ?, description = ?, property_type_id = ?, price = ?, deal_type = ?, listed_by = ? WHERE property_id = ?", [vals.title, vals.address, vals.suburb, vals.postcode, vals.state, vals.development_stage, vals.description, vals.ptype, vals.price, vals.deal_type, vals.developer, id], callback

exports.getPropertiesOfBarnDeal = (property_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}properties AS P WHERE P.deal_of = ?", [property_id], callback

exports.getPropertyByUserId = (user_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}properties AS P RIGHT JOIN #{db.prefix}users AS U ON p.listed_by = U.user_id WHERE listed_by = ?", [user_id], callback

exports.updateProperty = (values, callback) ->
  db.query "UPDATE #{db.prefix}properties SET bedrooms = ?, bathrooms = ?, cars = ?, internal_area = ?, external_area = ?", [values.bedrooms, values.bathrooms, values.cars, values.internal_area, values.external_area], callback

exports.addBarnDeal = (barn_id, property_id, callback) ->
  db.query "UPDATE #{db.prefix}properties SET deal_of = ? WHERE property_id = ?", [barn_id, property_id], callback

exports.removeBarnDeal = (property_id, callback) ->
  db.query "UPDATE #{db.prefix}properties SET deal_of = 0 WHERE property_id = ?", [property_id], callback

exports.search = (v, callback) ->
  db.query "SELECT P.* FROM #{db.prefix}properties AS P INNER JOIN #{db.prefix}property_types AS PT WHERE state LIKE ? AND PT.type LIKE ? AND price >= ? AND price <= ? AND bathrooms >= ? AND cars >= ? AND development_stage LIKE ? GROUP BY P.property_id", [v.state, v.pType, v.minPrice, v.maxPrice, v.bathrooms, v.cars, v.devStage], callback