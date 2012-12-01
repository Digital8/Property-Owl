{db} = require '../system'

table = "#{db.prefix}pages"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback

exports.findByUrl = (url, callback) ->
  db.query "SELECT * FROM #{table} WHERE url = ? AND static = 1", [url], callback

exports.find = (id, callback) ->
  db.query "SELECT * FROM #{table} WHERE page_id = ?", [id], callback
  
exports.create = (page, callback) ->
  db.query "INSERT INTO #{table}(url, header, content, enabled, page_created_at) VALUES(?,?,?,?, NOW())", [page.url, page.header, page.content, page.enabled], callback

exports.update = (page, callback) ->
  db.query "UPDATE #{table} SET url = ?, header = ?, content = ?, enabled = ? WHERE page_id = ?", [page.url, page.header, page.content, page.enabled, page.id], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM #{table} WHERE page_id = ?", [id], callback

exports.findByDynamicUrl = (url, callback) ->
  db.query "SELECT * FROM #{table} WHERE url = ? AND static = 0", [url], callback
