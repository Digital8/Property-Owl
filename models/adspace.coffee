db = require('../system').db

table = "#{db.prefix}advertisement"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback