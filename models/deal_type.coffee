Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class DealType extends Model
  
  @table = new Table
    name: 'deal_types'
    key: 'deal_type_id'
  
  @field 'name'