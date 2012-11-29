{db} = require '../system'

exports.getAllServices = (callback) ->
  db.query "SELECT * FROM #{db.prefix}services AS S INNER JOIN #{db.prefix}service_categories AS SC ON S.category_id = SC.category_id", callback

exports.getCategoryById = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}service_categories WHERE category_id = ?", [id], callback

exports.getServiceById = (id, callback) ->
  db.query "SELECT * FROM #{db.prefix}services AS S INNER JOIN #{db.prefix}service_categories AS SC ON S.category_id = SC.category_id WHERE S.service_id = ?", [id], callback
    
exports.getCountServicesByCategory = (cat_id, callback) ->
  db.query "SELECT COUNT(*) FROM #{db.prefix}services WHERE category_id = ?", [cat_id], callback 

exports.getAllServiceCategories = (callback) ->
  db.query "SELECT C.*, COUNT(S.service_id) AS cnt FROM #{db.prefix}service_categories AS C LEFT JOIN #{db.prefix}services AS S ON C.category_id = S.category_id GROUP BY C.category", callback
  
exports.createService = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}services(category_id, company, logo, phone, address, suburb, state, email, postcode, visible, description) VALUES(?,?,?,?,?,?,?,?,?,?,?)", [vals.category, vals.company, vals.logo, vals.phone, vals.address, vals.suburb, vals.state, vals.email, vals.postcode, vals.visible, vals.description], callback  
  
exports.updateService = (id, vals, callback) ->
  db.query "UPDATE #{db.prefix}services SET category_id = ?, company = ?, logo = ?, phone = ?, address = ?, suburb = ?, state = ?, email = ?, postcode = ?, visible = ?, description = ? WHERE service_id = ?", [vals.category, vals.company, vals.logo, vals.phone, vals.address, vals.suburb, vals.state, vals.email, vals.postcode, vals.visible, vals.description, id], callback

exports.updateCategory = (id, vals, callback) ->
  db.query "UPDATE #{db.prefix}service_categories SET category = ? WHERE category_id = ?", [vals.category, id], callback
  
exports.createCategory = (vals, callback) ->
  db.query "INSERT INTO #{db.prefix}service_categories(category) VALUES(?)", vals.category, callback
  
exports.deleteCategory = (id, callback) ->
  db.query "DELETE FROM #{db.prefix}service_categories WHERE category_id = ?", [id], callback

exports.deleteService = (id, callback) ->
  db.query "DELETE FROM #{db.prefix}services WHERE service_id = ?", [id], callback