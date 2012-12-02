async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

system = require '../system'

module.exports = class Media extends Model
  @table = new Table
    name: 'medias'
    key: 'media_id'
  
  # @belongsTo Model, as: 'owner'
  # @blongsTo Model, as: 'entity'
  
  @field 'filename'
  @field 'description'
  # @field 'image'
  # @field 'hero'
  
  constructor: (args = {}) ->
    super
  
  hydrate: (callback) ->
    super callback
  
  # deals: (callback) ->
  #   @db.query "SELECT * FROM deals WHERE #{@table.key} = ?", [@id], (error) ->
  #     return callback error if error
  
  #     callback null
  
  @for = (model, callback) =>
    @all (error, callback) ->
      console.log 'media', arguments

# {db} = require '../system'

# exports.getMediaByPropertyId = (property_id, callback) ->
#   db.query "SELECT * FROM #{db.prefix}media WHERE property_id = ? AND image = 0", [property_id], callback

# exports.addMedia = (mediaInfo, callback) ->
#   db.query "INSERT INTO #{db.prefix}media(property_id, owner_id, filename, description, image) VALUES(?,?,?,?,?)", [mediaInfo.property_id, mediaInfo.owner_id, mediaInfo.filename, mediaInfo.description, mediaInfo.image], callback
  
# exports.getImagesByPropertyId = (property_id, callback) ->
#   db.query "SELECT * FROM #{db.prefix}media WHERE image = true AND property_id = ? ORDER BY hero DESC", [property_id], callback

# exports.clearHero = (property_id, callback) ->
#   db.query "UPDATE #{db.prefix}media SET hero = 0 WHERE property_id = ?", [property_id], callback
  
# exports.setHero = (media_id, callback) ->
#   db.query "UPDATE #{db.prefix}media SET hero = 1 WHERE media_id = ?", [media_id], callback

# exports.deleteMedia = (media_id, callback) ->
#   db.query "DELETE FROM #{db.prefix}media WHERE media_id = ?", [media_id], callback