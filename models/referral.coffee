Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Referral extends Model
  
  @table = new Table
    name: 'referrals'
    key: 'referral_id'
  
  @field 'user_id'
  @field 'email'
  @field 'mobile'
  @field 'first_name'
  @field 'last_name'
  @field 'comment'
  @field 'entity_id'
  @field 'entity_type'
  @field 'created_at'
  
  hydrate: (callback) ->
    
    User.get @user_id, (error, user) =>
      callback error if error?
      @user = user
      super callback
  
  @getByUser = (user_id, callback) =>
    
    @db.query "SELECT * FROM #{@table.name} WHERE user_id = ?", [user_id], (error, rows) =>
      
      callback error, rows