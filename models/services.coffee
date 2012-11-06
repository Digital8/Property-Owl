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
  db.query "SELECT * FROM #{db.prefix}services", callback