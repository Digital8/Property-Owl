mysql = require 'mysql'

config = require './config'

module.exports = db = {}

db.connect = (callback) ->
  connection  = mysql.createConnection
    host: config.database.host
    user: config.database.user
    password: config.database.password
    database: config.database.name
  
  connection.connect (error) ->
    callback error, connection