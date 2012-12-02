{db} = require '../system'

exports.find = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}registrations WHERE registration_id = ?", [id], callback

exports.checkIfRegistered = (vals, callback) ->
  db.query "SELECT * FROM #{db.prefix}registrations WHERE resource_id = ? AND type = ? AND user_id = ?", [vals.id, vals.type, vals.user_id], callback

exports.add = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}registrations (resource_id, type, user_id) VALUES(?,?,?)", [vals.id, vals.type, vals.user_id], callback

exports.delete = (vals, callback) ->
  db.query "DELETE FROM #{db.prefix}registrations WHERE registration_id = ? and user_id = ?",[vals.id, vals.user_id], callback