###
 * Properties Model
 *
 * Handles all queries and actions to the database for the admin pages
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