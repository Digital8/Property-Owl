_ = require 'underscore'
async = require 'async'

module.exports = ({models, db, controllers}) ->
  
  for key, controller of controllers
    controller.db = db
    Object.defineProperty controller, 'models', value: models
  
  for key, controller of controllers.admin
    controller.db = db
    Object.defineProperty controller, 'models', value: models
  
  async.map (_.values models), (model, callback) ->
    
    model.db = db
    Object.defineProperty model, 'models', value: models
    
    db.query "SHOW COLUMNS FROM #{model.table.name}", (error, rows) ->
      
      return callback error if error?
      
      for field in rows
        
        model.table.columns[field.Field] = field
      
      callback null
  
  , (error) ->
    
    console.log error if error?