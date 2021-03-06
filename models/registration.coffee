async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Registration extends Model
  
  @table = new Table
    name: 'registrations'
    key: 'registration_id'
  
  @field 'user_id'
  @field 'entity_id'
  @field 'entity_type'
  
  @field 'phone', type: String, required: yes
  @field 'comment', type: String, required: yes
  
  hydrate: (callback) ->
    async.parallel
      user: (callback) => User.dry @user_id, callback
      entity: (callback) => @constructor.models[@entity_type].dry @entity_id, callback
    , (error, map) =>
      return callback error if error?
      {@user, @entity} = map
      super callback
  
  @registered = ({entity, user}, callback) ->
    @db.query """
    SELECT *
    FROM   registrations
    WHERE  entity_id = ?
           AND entity_type = ?
           AND user_id = ?
           AND status
    """, [
      entity.id
      entity.constructor.name.toLowerCase()
      user.id
    ], (error, rows) ->
      return callback error if error?
      callback null, rows.length > 0
  
  @forUser = (user, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE user_id = ? AND status", [user.id], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback
  
  @report = (cred, callback) ->
    
    vals = []
    
    query = """
    SELECT
      U.first_name,
      U.last_name,
      R.created_at,
      count(registration_id) AS total
    FROM registrations AS R
    INNER JOIN users AS U ON R.user_id = U.user_id
    """
    
    if cred.month != ''
      console.log cred
      query += ' AND MONTH(R.created_at) = ?'
      vals.push cred.month

    query += ' GROUP BY U.user_id'
    
    @db.query query, vals, callback