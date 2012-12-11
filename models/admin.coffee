{db} = require '../system'

exports.getAdminPagesByAccess = (rights, callback) ->
  db.query "SELECT * FROM po_admin WHERE PAC IN ('" + rights.join("','") + "')", callback

exports.getAdminPages = (callback) ->
  db.query "SELECT * FROM po_admin_pages", callback