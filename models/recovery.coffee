{db} = require '../system'

exports.add = (vals, callback) ->
  db.query "INSERT INTO recovery (email, code) VALUES(?, ?)", [vals.email, vals.code], callback

exports.delete = (email, callback) ->
  db.query "DELETE FROM recovery WHERE email = ?", [email], callback

exports.check = (vals, callback) ->
  db.query "SELECT * FROM recovery WHERE email = ? AND code = ? LIMIT 1", [vals.email, vals.code], callback