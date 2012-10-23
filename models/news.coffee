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
  db.query "SELECT * FROM #{db.prefix}news AS N INNER JOIN #{db.prefix}users AS U on N.user_id = U.user_id ORDER BY N.posted_at DESC", callback

exports.getNewsById = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}news AS N INNER JOIN #{db.prefix}users AS U on N.user_id = U.user_id where N.news_id = ?", [id], callback

exports.insert = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}news (user_id, title, content) VALUES(?, ?, ?)", [vals.id, vals.title, vals.content], callback

exports.update = (vals, callback) ->
  db.query "UPDATE #{db.prefix}news SET title = ?, content = ? WHERE news_id = ?", [vals.title, vals.content, vals.id], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM #{db.prefix}news WHERE news_id = ?", [id], callback
