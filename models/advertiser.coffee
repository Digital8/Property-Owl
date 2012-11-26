db = require('../system').db

table = "#{db.prefix}advertisers"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback

exports.find = (id, callback) ->
  db.query "SELECT * FROM #{table} WHERE advertiser_id = ?", [id], callback

exports.create = (advertiser, callback) ->
  console.dir advertiser
  
  db.query "INSERT INTO #{table} (name,description,contactee,email,phone,address,suburb,state,postcode) VALUES(?,?,?,?,?,?,?,?,?)", [advertiser.name, advertiser.description, advertiser.contactee, advertiser.email, advertiser.phone, advertiser.address, advertiser.suburb, advertiser.state, advertiser.postcode], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM #{table} WHERE advertiser_id = ?", [id], callback