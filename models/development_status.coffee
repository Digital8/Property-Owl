Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class DevelopmentStatus extends Model
  @table = new Table
    name: 'development_statuses'
    key: 'development_status_id'
  
  @field 'name'
  
  constructor: (args = {}) ->
    super