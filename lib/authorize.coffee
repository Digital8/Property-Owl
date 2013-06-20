module.exports = (acl) ->
  
  (req, res, next) ->
    
    if req.user?.isAdmin()
      return next? null
    
    if req.user?.level is acl
      return next? null
    
    req.session.redirect_to = req.url
    
    res.redirect '/login'