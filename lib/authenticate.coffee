module.exports = (req, res, next) ->
  
  return next? null if req.session.user_id?
  
  req.session.redirect_to = req.url
  
  res.redirect '/login'