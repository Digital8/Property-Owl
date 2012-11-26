db = require('../system').db

table = "#{db.prefix}advertisements"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback