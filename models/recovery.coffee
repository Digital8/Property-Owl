Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Recovery extends Model
  
  @table = new Table
    name: 'recoveries'
    key: 'recovery_id'
  
  @add = (vals, callback) ->
    @db.query "INSERT INTO recovery (email, code) VALUES(?, ?)", [vals.email, vals.code], callback
  
  @delete = (email, callback) ->
    @db.query "DELETE FROM recovery WHERE email = ?", [email], callback
  
  @check = (vals, callback) ->
    @db.query "SELECT * FROM recovery WHERE email = ? AND code = ? LIMIT 1", [vals.email, vals.code], callback