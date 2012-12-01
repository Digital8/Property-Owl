Model = require '../lib/model'

module.exports = class Barn extends Model
  @table.name = 'barns'
  
  constructor: (args) ->
  
  @all = (callback) ->
    @db.query "SELECT * FROM barns", (error, rows) ->
    # @db.query "SELECT * FROM #{@table.name}", (error, rows) ->
      return callback error if error
      
      models = []
      
      for row in rows
        model = new Barn row
        models.push model
      
      callback null, models