{db} = require '../system'

exports.login = (email, password, callback) ->
  db.query "SELECT * FROM #{db.prefix}users WHERE email = ? AND password = ?", [email, password], callback

exports.getAllUsers = (callback) ->
  db.query "SELECT U.*, AT.name AS account_type FROM #{db.prefix}users AS U INNER JOIN #{db.prefix}account_types AS AT ON U.account_type_id = AT.account_type_id ", callback
  
exports.getUserById = (user_id, callback) ->
  db.query "SELECT U.*, AT.name AS account_type FROM #{db.prefix}users as U INNER JOIN #{db.prefix}account_types AS AT ON U.account_type_id = AT.account_type_id WHERE user_id = ?", [user_id], callback
  
exports.getUserByAlias = (user_alias, callback) ->
  db.query "SELECT * FROM #{db.prefix}users WHERE alias = ?", [user_alias], callback
  
exports.getUsersByGroup = (group, callback) ->
  db.query "SELECT * FROM #{db.prefix}users AS U INNER JOIN #{db.prefix}account_types AS AT ON U.account_type_id = AT.account_type_id WHERE AT.account_type_id = ?", [group], callback

exports.getAllGroups = (callback) ->
  db.query "SELECT * FROM #{db.prefix}account_types", callback

exports.getUserByEmail = (email, callback) ->
  db.query "SELECT * FROM #{db.prefix}users WHERE email = ?", [email], callback

exports.createUser = (user, callback) ->
  db.query "INSERT INTO #{db.prefix}users (email,password,first_name,last_name,account_type_id) VALUES(?,?,?,?,?)", [user.email, user.password, user.fname, user.lname, user.group], callback

exports.updateUser = (user, callback) ->
  db.query "UPDATE #{db.prefix}users SET email = ?, first_name = ?, last_name = ?, company = ?, phone = ?, work_phone = ?, mobile = ?, address = ?, suburb = ?, state = ?, postcode = ?, subscribed_newsletter = ?, subscribed_alerts = ? WHERE user_id = ?", [user.email, user.fname, user.lname, user.company, user.phone, user.work_phone, user.mobile, user.address, user.suburb, user.state, user.postcode, user.subscribed_news, user.property_alerts,user.id], callback

exports.updatePassword = (user, callback) ->
  db.query "UPDATE #{db.prefix}users SET password = ? WHERE user_id = ?", [user.password, user.id], callback

exports.updatePermissions = (user_id, permissions,callback) ->
  db.query "UPDATE #{db.prefix}users SET admin_rights = ? WHERE user_id = ?", [permissions, user_id], callback

exports.updateAvatar = (user_id, fileName, callback) ->
  db.query "UPDATE #{db.prefix}users SET photo = ? WHERE user_id = ?", [fileName, user_id], callback