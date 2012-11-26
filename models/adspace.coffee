db = require('../system').db

table = "#{db.prefix}adspaces"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback