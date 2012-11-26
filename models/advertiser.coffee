db = require('../system').db

table = "#{db.prefix}advertisers"

exports.all = (callback) ->
  db.query "SELECT * FROM #{table}", callback

exports.create = (advertiser, callback) ->
  console.dir advertiser
  
  db.query "INSERT INTO #{table} (name,description,contactee,email,phone,address,suburb,state,postcode) VALUES(?,?,?,?,?,?,?,?,?)", [advertiser.email, advertiser.password, advertiser.fname, advertiser.lname, advertiser.group], callback