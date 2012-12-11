{db} = require '../system'

table = "po_adspaces"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback