{db} = require '../system'

exports.getAllNews = (callback) ->
  db.query "SELECT * FROM po_news AS N INNER JOIN po_users AS U on N.user_id = U.user_id ORDER BY N.posted_at DESC", callback

exports.getAllNewsByType = (type, callback) ->
  db.query "SELECT * FROM po_news AS N INNER JOIN po_users AS U on N.user_id = U.user_id WHERE N.news_type = ? ORDER BY N.posted_at DESC", [type], callback

exports.getNewsById = (id, callback) ->
  db.query "SELECT * FROM po_news AS N INNER JOIN po_users AS U on N.user_id = U.user_id WHERE N.news_id = ?", [id], callback

exports.insert = (vals, callback) ->
  db.query "INSERT INTO po_news (user_id, title, content) VALUES(?, ?, ?)", [vals.id, vals.title, vals.content], callback

exports.update = (vals, callback) ->
  db.query "UPDATE po_news SET title = ?, content = ? WHERE news_id = ?", [vals.title, vals.content, vals.id], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM po_news WHERE news_id = ?", [id], callback