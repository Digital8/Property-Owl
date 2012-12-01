{db} = require '../system'

table = "#{db.prefix}advertisers"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback

exports.find = (id, callback) ->
  db.query "SELECT * FROM #{table} WHERE advertiser_id = ?", [id], callback

exports.create = (advertiser, callback) ->
  console.dir advertiser
  
  db.query "INSERT INTO #{table} (name,description,contactee,email,phone,address,suburb,state,postcode) VALUES(?,?,?,?,?,?,?,?,?)", [advertiser.name, advertiser.description, advertiser.contactee, advertiser.email, advertiser.phone, advertiser.address, advertiser.suburb, advertiser.state, advertiser.postcode], callback

exports.update = (advertiser, callback) ->
  db.query "UPDATE #{table} SET name = ?, description = ?, contactee = ?, email = ?, phone = ?, address = ?, suburb = ?, state = ?, postcode = ? WHERE advertiser_id = ?", [advertiser.name, advertiser.description, advertiser.contactee, advertiser.email, advertiser.phone, advertiser.address, advertiser.suburb, advertiser.state, advertiser.postcode, advertiser.id], callback

exports.delete = (id, callback) ->
  db.query "DELETE FROM #{table} WHERE advertiser_id = ?", [id], callback