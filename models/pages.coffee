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

exports.getAllPages = (callback) ->
  db.query "SELECT * FROM #{db.prefix}pages", callback
  
exports.getPageByUrl = (url, callback) ->
  db.query "SELECT * FROM #{db.prefix}pages WHERE url = ?", [url], callback

exports.getPageById = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}pages WHERE page_id = ?", [id], callback
  
exports.createPage = (page, callback) ->
  db.query "INSERT INTO #{db.prefix}pages(url, header, content, enabled, page_created_at) VALUES(?,?,?,?, NOW())", [page.url, page.header, page.content, page.enabled], callback