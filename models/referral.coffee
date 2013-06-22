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
      user: (callback) => User.dry @user_id, callback
      entity: (callback) => @constructor.models[@entity_type].dry @entity_id, callback
    , (error, map) =>
      return callback error if error?
      {@user, @entity} = map
      super callback
  
  @forUser = (user, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE user_id = ?", [user.id], (error, rows) =>
      
      return callback error if error?
      
      async.map rows, @new.bind(this), callback