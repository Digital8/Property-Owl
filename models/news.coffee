###
 * News Model
 *
 * Handles all queries and actions to the database for the site news
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.getAllNews = (callback) ->
  db.query "SELECT * FROM #{db.prefix}news AS N INNER JOIN #{db.prefix}users AS U on N.user_id = U.user_id", callback