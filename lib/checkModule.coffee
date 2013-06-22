system = require '../../system'

module.exports = (module) ->
  (req,res,next) ->
    if system.config.modules?[module] is true
      next()
    else
      res.render 'errors/deactivated'