{db} = require '../system'

exports.getAllNewsByType = (type, callback) ->
  db.query "SELECT * FROM #{db.prefix}news AS N INNER JOIN #{db.prefix}users AS U on N.user_id = U.user_id WHERE N.type = ? ORDER BY N.posted_at DESC", [type], callback

exports.getNewsById = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}news AS N INNER JOIN #{db.prefix}users AS U on N.user_id = U.user_id WHERE N.news_id = ?", [id], callback

exports.insert = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}news (user_id, title, content) VALUES(?, ?, ?)", [vals.id, vals.title, vals.content], callback

exports.update = (vals, callback) ->
  db.query "UPDATE #{db.prefix}news SET title = ?, content = ? WHERE news_id = ?", [vals.title, vals.content, vals.id], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM #{db.prefix}news WHERE news_id = ?", [id], callback
