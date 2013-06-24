module.exports = ->
  (req, res, next) ->
    req.guard = (req, res, done) ->
      errors = req.validationErrors()
      if errors
        done errors
      else
        delete req._validationErrors
      return errors
    next null