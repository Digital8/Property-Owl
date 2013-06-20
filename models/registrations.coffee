Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Registration extends Model
  
  @table = new Table
    name: 'registrations'
    key: 'registration_id'
  
  @find = (id, callback) ->
    @db.query "SELECT * FROM po_registrations WHERE registration_id = ?", [id], callback
  
  @checkIfRegistered = (vals, callback) ->
    @db.query "SELECT * FROM po_registrations WHERE resource_id = ? AND type = ? AND user_id = ? AND status = 1", [vals.id, vals.type, vals.user_id], callback
  
  @add = (vals, callback) ->
    @db.query "INSERT INTO po_registrations (resource_id, type, user_id) VALUES(?,?,?)", [vals.id, vals.type, vals.user_id], callback
  
  @delete = (vals, callback) ->
    @db.query "UPDATE po_registrations SET status = 0 WHERE registration_id = ? and user_id = ?", [vals.id, vals.user_id], callback
  
  @findByUser = (user_id, callback) ->
    @db.query "SELECT * FROM po_registrations WHERE user_id = ?", [user_id], callback
  
  @changeStatus = (vals, callback) ->
    @db.query "UPDATE po_registrations SET status = ? WHERE registration_id = ?", [vals.val, vals.id], callback
  
  @report = (cred, callback) ->
    
    vals = []
    
    query = "SELECT U.first_name, U.last_name, R.registered_at, count(registration_id) AS total FROM po_registrations AS R INNER JOIN po_users AS U ON R.user_id = U.user_id "
    
    if cred.month != ''
      console.log cred
      query += ' AND MONTH(R.registered_at) = ?'
      vals.push cred.month

    query += ' GROUP BY U.user_id'
    
    @db.query query, vals, callback