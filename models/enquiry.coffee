_ = require 'underscore'
async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Enquiry extends Model
  @table = new Table
    name: 'enquiries'
    key: 'enquiry_id'
  
  @field 'user_id'
  
  @field 'entity_id'
  @field 'entity_type'
  
  @field 'enquiry'
  
  @field 'created_at'
  @field 'updated_at'
  
  @for = (model, callback) =>
    type = model.constructor.name.toLowerCase()
    
    system.db.query "SELECT * FROM enquiries WHERE entity_id = ? AND entity_type = '#{type}'", [model.id], (error, rows) =>
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models