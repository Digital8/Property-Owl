{db} = require '../system'

exports.find = (id, callback) ->
  db.query "SELECT * FROM po_registrations WHERE registration_id = ?", [id], callback

exports.checkIfRegistered = (vals, callback) ->
  db.query "SELECT * FROM po_registrations WHERE resource_id = ? AND type = ? AND user_id = ?", [vals.id, vals.type, vals.user_id], callback

exports.add = (vals, callback) ->
  db.query "INSERT INTO po_registrations (resource_id, type, user_id) VALUES(?,?,?)", [vals.id, vals.type, vals.user_id], callback

exports.delete = (vals, callback) ->
  db.query "DELETE FROM po_registrations WHERE registration_id = ? and user_id = ?",[vals.id, vals.user_id], callback

exports.findByUser = (user_id, callback) ->
  db.query "SELECT * FROM po_registrations WHERE user_id = ?", [user_id], callback

exports.report = (cred, callback) ->
  vals = []
  query = "SELECT U.first_name, U.last_name, R.registered_at, count(registration_id) AS total FROM po_registrations AS R INNER JOIN po_users AS U ON R.user_id = U.user_id GROUP BY U.user_id"
  db.query query, vals, callback