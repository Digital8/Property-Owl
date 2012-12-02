Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class DevelopmentType extends Model
  @table = new Table
    name: 'development_types'
    key: 'development_type_id'
  
  constructor: (args = {}) ->
    super