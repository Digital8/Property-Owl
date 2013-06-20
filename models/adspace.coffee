Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Adspace extends Model
  
  @table = new Table
    name: 'adspaces'
    key: 'adspace_id'
  
  @field 'name'