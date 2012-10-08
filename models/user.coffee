###
 * User Model
 *
 * Handles all queries and actions to the database for the user
 *
 * @package   Time for Advice
 * @author    Brendan Scarvell <bscarvell@gmail.com>
 * @copyright Copyright (c) 2012 - Current
 ###

db = require('../system').db

exports.login = (email, password, callback) ->
  db.query "SELECT * FROM #{db.prefix}users WHERE email = ? AND password = ?"
  , [email, password], callback

exports.getAllUsers = (callback) ->
  db.query "SELECT * FROM #{db.prefix}users ORDER BY acl DESC", callback
  
exports.getUserById = (user_id, callback) ->
  db.query "SELECT * FROM #{db.prefix}users as U INNER JOIN #{db.prefix}account_types AS AT ON U.account_type_id = AT.account_type_id WHERE user_id = ?", [user_id], callback
  
exports.getUserByAlias = (user_alias, callback) ->
  db.query "SELECT * FROM #{db.prefix}users WHERE alias = ?", [user_alias], callback

exports.getUserByEmail = (email, callback) ->
  db.query "SELECT * FROM #{db.prefix}users WHERE email = ?", [email], callback

exports.createUser = (user, callback) ->
  db.query "INSERT INTO #{db.prefix}users (email,password,first_name,last_name) VALUES(?,?,?,?)", [user.email, user.password, user.fname, user.lname], callback

exports.updateUser = (user, callback) ->
  db.query "UPDATE #{db.prefix}users SET email = ?, first_name = ?, last_name = ? WHERE user_id = ?", [user.email, user.fname, user.lname, user.id], callback

exports.updatePassword = (user,callback) ->
  db.query "UPDATE #{db.prefix}users SET password = ? WHERE user_id = ?", [user.password, user.id], callback

exports.updatePermissions = (user_id, permissions,callback) ->
  db.query "UPDATE #{db.prefix}users SET admin_rights = ? WHERE user_id = ?", [permissions, user_id], callback

exports.updateAvatar = (user_id, fileName, callback) ->
  db.query "UPDATE #{db.prefix}users SET photo = ? WHERE user_id = ?", [fileName, user_id], callback