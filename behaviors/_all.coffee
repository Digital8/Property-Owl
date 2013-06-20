async = require 'async'

module.exports = (req, res, models, callback) ->
  
  models ?= []
  
  async.map models, (model, callback) ->
    model.all (error, instances) ->
      return callback error if error?
      res.locals[model.table.name] = instances
      callback null
  , callback