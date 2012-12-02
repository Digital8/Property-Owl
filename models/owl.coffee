Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Owl extends Model
  @table = new Table
    name: 'owls'
    key: 'owl_id'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    DevelopmentType = system.models.development_type
    
    DevelopmentType.get @development_type_id, (error, developmentType) =>
      @type = developmentType
      super callback
  
  deals: (callback) ->
    @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
      return callback error if error
      
      callback null
  
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