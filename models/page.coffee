async = require 'async'
jade = require 'jade'

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
  @field 'type'
  @field 'key'
  
  constructor: (args = {}) ->
    
    super
    
    Object.defineProperty this, 'html', get: =>
      try
        return do (jade.compile @content, req: @req)
      catch e
        console.log 'could not render page', @id, e
        return ''
  
  @cms = (url, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE url = ? AND type = 'page' LIMIT 1", [url], (error, rows) =>
      return callback error if error?
      return callback 404 unless rows.length is 1
      @new rows[0], callback
  
  @block = (url, key, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE url = ? AND type = 'block' AND `key` = ? LIMIT 1", [url, key], (error, rows) =>
      return callback error if error?
      return callback 404 unless rows.length is 1
      @new rows[0], callback
  
  @route = (url, callback) ->
    @db.query "SELECT * FROM #{@table.name} WHERE type = 'page' OR type = 'route' LIMIT 1", [url], (error, rows) =>
      return callback error if error?
      async.map rows, @new.bind(this), callback