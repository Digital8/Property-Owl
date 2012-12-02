{db} = require '../system'

class Table
  constructor: (args = {}) ->
    @name = args.name

module.exports = class Model
  @table = new Table
  
  constructor: (args = {}) ->
    console.log args
  
  @all = (callback) ->
    db.query "SELECT * FROM #{@table.name}", (error, rows) ->
      return callback error if error
      
      models = []
      
      for row in rows
        model = new @ row
        models.push model
      
      callback null, models

Model.db = db