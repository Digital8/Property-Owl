{db} = require '../system'

exports.add = (data, callback) ->
  db.query "INSERT INTO clicks(advertisement_id,ip_address, referer, user_agent, user_id, req) VALUES(?,?,?,?,?,?)", [data.id, data.ip, data.referer, data.browser, data.user_id, data.req], callback