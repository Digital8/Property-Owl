async = require 'async'

Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class User extends Model
  
  @table = new Table
    name: 'users'
    key: 'user_id'
  
  @field 'first_name', type: String, required: yes
  @field 'last_name', type: String, required: yes
  
  @field 'email', type: String, required: yes
  
  @field 'address', type: String
  @field 'suburb', type: String
  @field 'state', type: String
  @field 'postcode', type: String, required: yes
  
  @field 'company', type: String
  
  @field 'phone', type: String
  @field 'work_phone', type: String
  @field 'mobile', type: String
  
  @field 'subscribed_newsletter', type: Boolean
  @field 'subscribed_alerts', type: Boolean
  
  constructor: (args = {}) ->
    
    Object.defineProperty this, 'level', get: => @account_type_id
    Object.defineProperty this, 'name', get: => "#{@first_name} #{@last_name}"
    Object.defineProperty this, 'preferences', get: =>
      suburb: @pref_suburb or ''
      state: @pref_state or ''
      propertyType: @pref_ptype or ''
      dealType: @pref_dtype or ''
      minPrice: @pref_min_price or ''
      maxPrice: @pref_max_price or '' 
      minBeds: @pref_min_beds or ''
      maxBeds: @pref_max_beds or ''
      bathrooms: @pref_bathrooms or ''
      cars: @pref_cars or ''
      developmentStage: @pref_dev_stage or ''
    
    super
  
  isHacker: ->
    return no unless app?.argv?.hack
    return no unless @company is 'Digital8'
    return yes
  
  isBuyer: ->
    @level >= 1
  
  isDeveloper: ->
    @level >= 2
  
  isAdmin: ->
    @level >= 3
  
  @developers = (callback) =>
    async.parallel
      developers: (callback) => @getUsersByGroup 2, callback
      admins: (callback) => @getUsersByGroup 3, callback
    , (error, results) =>
      return callback error if error?
      return callback null, [results.developers..., results.admins...]
  
  @byEmail = (email, callback) =>
    
    @db.query "SELECT * FROM users WHERE email = ?", [email], (error, rows) =>
      
      return callback error if error?
      return callback null, null unless rows.length
      
      instance = new this rows[0]
      
      instance.hydrate callback
  
  @getUsersByGroup = (group, callback) =>
    @db.query """
    SELECT * FROM users AS U
    INNER JOIN account_types AS AT ON U.account_type_id = AT.account_type_id
    WHERE AT.account_type_id = ?
    """, [group], (error, rows) ->
      return callback error if error?
      callback null, rows
  
  @getAllGroups = (callback) =>
    @db.query "SELECT * FROM account_types", (error, rows) ->
      return callback error if error?
      callback null, rows
  
  # @updateGroup = (user, callback) =>
  #   @db.query "UPDATE po_users SET account_type_id = ? WHERE user_id = ?", [user.group, user.id], callback
  
  # @updateUser = (user, callback) =>
  #   @db.query "UPDATE po_users SET email = ?, first_name = ?, last_name = ?, company = ?, phone = ?, work_phone = ?, mobile = ?, address = ?, suburb = ?, state = ?, postcode = ?, subscribed_newsletter = ?, subscribed_alerts = ? WHERE user_id = ?", [user.email, user.fname, user.lname, user.company, user.phone, user.work_phone, user.mobile, user.address, user.suburb, user.state, user.postcode, user.subscribed_news, user.property_alerts,user.id], callback
  
  # @updatePassword = (user, callback) =>
  #   @db.query "UPDATE po_users SET password = ? WHERE user_id = ?", [user.password, user.id], callback
  
  @thisMonth = (callback) =>
    @db.query "SELECT * FROM users AS U WHERE U.created_at BETWEEN date_format(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') AND last_day(NOW())", (error, rows) ->
      return callback error if error?
      callback null, rows
  
  @search = (name, callback) =>
    @db.query """
    SELECT U.*, AT.name AS account_type
    FROM users AS U
    INNER JOIN account_types AS AT ON U.account_type_id = AT.account_type_id
    WHERE CONCAT( U.first_name,  ' ', U.last_name ) LIKE ?
    """, [name], (error, rows) ->
      return callback error if error?
      callback null, rows
  
  @getByMonth = (cred, callback) =>
    if cred?.month?.length
      @db.query """
      SELECT count(user_id) AS total, first_name, last_name, state, created_at
      FROM users
      WHERE state LIKE ? AND MONTH(created_at) = ?
      GROUP BY state
    """, [cred.state, cred.month], callback
    
    else
      @db.query """
      SELECT count(user_id) AS total, state, created_at
      FROM users
      WHERE state LIKE ?
      GROUP BY state
      """, [cred.state], callback