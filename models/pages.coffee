###
 * Custom Pages Model
 *
 * Handles all queries and actions to the database for the custom pages
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getPageByUrl = (url, callback) ->
  db.query "SELECT * FROM #{db.prefix}pages WHERE url = ? AND enabled = 1", [url], callback