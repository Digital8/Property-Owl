###
 * Services Model
 *
 * Handles all queries and actions to the database for the services
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <bscarvell@gmail.com>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getAllServices = (callback) ->
  db.query "SELECT * FROM #{db.prefix}services AS S INNER JOIN #{db.prefix}service_categories AS SC ON S.category_id = SC.category_id", callback

exports.getCountServicesByCategory = (cat_id, callback) ->
  db.query "SELECT COUNT(*) FROM #{db.prefix}services WHERE category_id = ?", [cat_id], callback 

exports.getAllServiceCategories = (callback) ->
  db.query "SELECT * FROM #{db.prefix}service_categories", callback
  
exports.createService = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}services(category_id, company, logo, phone, address, suburb, state, email, postcode, visible, description) VALUES(?,?,?,?,?,?,?,?,?,?,?)", [vals.category, vals.company, vals.logo, vals.phone, vals.address, vals.suburb, vals.state, vals.email, vals.postcode, vals.visible, vals.description], callback  
  
exports.createCategory = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}service_categories(category) VALUES(?)", vals.category, callback