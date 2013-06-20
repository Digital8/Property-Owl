Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Page extends Model
  
  @table = new Table
    name: 'pages'
    key: 'page_id'
  
  @field 'url'
  @field 'header'
  @field 'content'
  @field 'enabled'
  
  @findByUrl = (url, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE url = ? AND static = 1", [url], (error, records) ->
      return callback error if error?
      callback null, records[0]
  
  @findByDynamicUrl = (url, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE url = ? AND static = 0", [url], (error, records) ->
      return callback error if error?
      callback null, records[0]