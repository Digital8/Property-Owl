{db} = require '../system'

module.exports = class Model
  @db = db
  
  constructor: (args = {}) ->
    for key, value of args
      @[key] = value
    
    @id = this[@constructor.table.key]
  
  @all = (callback) ->
    @db.query "SELECT * FROM #{@table.name}", (error, rows) =>
      return callback error if error
      
      models = []
      
      for row in rows
        models.push (new this row)
      
      callback null, models

Model.db = db