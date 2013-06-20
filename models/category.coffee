Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Category extends Model
  
  @table = new Table
    name: 'categories'
    key: 'category_id'
  
  @field 'key'
  @field 'entity_type'
  
  @for = (key, callback) =>
    
    @db.query "SELECT * FROM categories WHERE entity_type = ? ORDER BY `key`", [key], (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models