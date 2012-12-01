Model = require '../lib/model'

module.exports = class Owl extends Model
  @table.name = 'owls'
  
  constructor: (args = {}) ->
    for key, value of args
      @[key] = value
    
    super
  
  @all = (callback) ->
    @db.query "SELECT * FROM #{@table.name}", (error, rows) ->
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Owl row
        models.push model
      
      callback null, models
  
  @get = (id, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE barn_id = ?", [id], (error, rows) ->
      return callback error if error
      
      callback null, new Owl rows[0]
  
  @state = (state, callback) ->
    console.log state
    
    @db.query "SELECT * FROM #{@table.name} WHERE state = ?", [state], (error, rows) ->
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
        
        # owls.push new @constructor row
      
      # console.log owls
    
    # @all (error, owls) ->
    #   return callback error if error
      
    #   return callback new Error 'no owls' unless owls.length
      
    #   owl = owls.pop()
      
    #   callback null, owl