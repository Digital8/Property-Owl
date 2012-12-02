Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Owl extends Model
  @table = new Table
    name: 'owls'
    key: 'owl_id'
  
  constructor: (args = {}) ->
    super
  
  deals: (callback) ->
    @db.query "SELECT * FROM deals WHERE owl_id = ?", [@id], (error) ->
      return callback error if error
      
      callback null
  
  @delete = (id, callback) ->
    @db.query "DELETE FROM #{@table.name} WHERE owl_id = ?", [id], (error) ->
      return callback error if error
      
      callback null
  
  # @all = (callback) ->
  #   @db.query "SELECT * FROM #{@table.name}", (error, rows) ->
  #     return callback error if error
      
  #     models = []
      
  #     for row in rows
  #       model = new Owl row
  #       models.push model
      
  #     callback null, models
  
  @get = (id, callback) ->
    @db.query "SELECT * FROM owls WHERE owl_id = ?", [id], (error, rows) ->
      return callback error if error
      
      callback null, new Owl rows[0]
  
  @state = (state, callback) ->
    console.log state
    
    @db.query "SELECT * FROM #{@table.name} WHERE state = ? ORDER BY created_at ASC", [state], (error, rows) ->
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Owl row
        models.push model
      
      callback null, models
  
  @top = (callback) ->
    @db.query """
    SELECT
      *,
      discount / price AS ratio
      FROM (
        SELECT
        *,
        (
          SELECT SUM(value)
           FROM deals
           WHERE owl_id = OWLS.owl_id
        ) AS discount
    FROM owls AS OWLS
    WHERE approved
    HAVING discount) AS TEMP
    ORDER BY ratio DESC
    LIMIT 1
    """, (error, rows) ->
      return callback error if error
      
      callback null, new Owl rows[0]