module.exports = (req, res, next) ->
  
  return next? null if req.user?
  
  next? 401