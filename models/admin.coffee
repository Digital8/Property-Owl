###
 * Admin Model
 *
 * Handles all queries and actions to the database for the admin pages
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getAdminPagesByAccess = (rights, callback) ->
  db.query "SELECT * FROM #{db.prefix}admin WHERE PAC IN ('" + rights.join("','") + "')", callback

exports.getAdminPages = (callback) ->
  db.query "SELECT * FROM #{db.prefix}admin_pages", callback