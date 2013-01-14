system = require '../system'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Category extends Model
  @table = new Table
    name: 'categories'
    key: 'category_id'
  
  @field 'key'
  
  constructor: (args = {}) ->
    super
  
  @for = (key, callback) =>
    # type = model.constructor.name.toLowerCase()
    
    # console.log 'type', type, model.constructor.name
    
    system.db.query "SELECT * FROM categories WHERE entity_type = ?", [key], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models