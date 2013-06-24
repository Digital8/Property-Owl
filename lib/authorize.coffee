module.exports = (acl) ->
  
  (req, res, next) ->
    
    if req.user?.isAdmin()
      return next? null
    
    if req.user?.level is acl
      return next? null
    
    return next 403 if req.xhr
    
    req.session.redirect_to = req.url
    
    res.redirect '/login'