async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Referral extends Model
  
  @table = new Table
    name: 'referrals'
    key: 'referral_id'
  
  @field 'user_id'
  
  @field 'first_name'
  @field 'last_name'
  @field 'email'
  @field 'mobile'
  
  @field 'comment'
  
  @field 'entity_id'
  @field 'entity_type'
  
  @field 'created_at'
  @field 'updated_at'
  
  constructor: (args = {}) ->
    Object.defineProperty this, 'name', get: => "#{@first_name} #{@last_name}"
    super
  
  hydrate: (callback) ->
    async.parallel
      user: (callback) =>
        User.get @user_id, (error, user) =>
          @user = user
          callback error
      entity: (callback) =>
        @constructor.models[@entity_type].dry @entity_id, (error, entity) =>
          @entity = entity
          callback error
    , (error) =>
      super callback
  
  @getByUser = (user_id, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE user_id = ?", [user_id], (error, rows) =>
      
      callback error, rows