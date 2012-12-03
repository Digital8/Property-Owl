Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Barn extends Model
  @table = new Table
    name: 'barns'
    key: 'barn_id'
  
  @field 'title'
  @field 'address'
  @field 'suburb'
  @field 'postcode'
  @field 'state'
  @field 'description'
  
  constructor: (args = {}) ->
    super
  
  # @all = (callback) ->
  #   @db.query "SELECT * FROM barns", (error, rows) ->
  #   # @db.query "SELECT * FROM #{@table.name}", (error, rows) ->
  #     return callback error if error
      
  #     models = []
      
  #     for row in rows
  #       model = new Barn row
  #       models.push model
      
  #     callback null, models