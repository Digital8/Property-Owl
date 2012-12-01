{db} = require '../system'

exports.getAdminPagesByAccess = (rights, callback) ->
  db.query "SELECT * FROM #{db.prefix}admin WHERE PAC IN ('" + rights.join("','") + "')", callback

exports.getAdminPages = (callback) ->
  db.query "SELECT * FROM #{db.prefix}admin_pages", callback