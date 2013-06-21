Model = require '../lib/model'
Table = require '../lib/table'

module.exports = class Enquiry extends Model
  
  @table = new Table
    name: 'enquiries'
    key: 'enquiry_id'
  
  @field 'user_id'
  
  @field 'entity_id'
  @field 'entity_type'
  
  @field 'comment'
  
  @field 'created_at'
  @field 'updated_at'
  
  @for = (model, callback) =>
    
    type = model.constructor.name.toLowerCase()
    
    @db.query "SELECT * FROM enquiries WHERE entity_id = ? AND entity_type = '#{type}'", [model.id], (error, rows) =>
      
      return callback error if error?
      
      models = (new this row for row in rows)
      
      callback null, models
  
  @report = (cred, callback) ->
    
    vals = []
    
    query  = """
    SELECT A.name, E.created_at as date, count(E.enquiry_id) AS total
    FROM enquiries AS E
    INNER JOIN affiliates AS A on E.entity_id = A.affiliate_id
    WHERE E.entity_type = 'affiliate'
    """
    
    if cred.month != ''
      console.log cred
      query += ' AND MONTH(E.created_at) = ?'
      vals.push cred.month
    
    @db.query query, vals, callback