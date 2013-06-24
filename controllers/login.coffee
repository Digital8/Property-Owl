exports.get = (req, res) ->
  
  res.render 'user/login'

exports.post = (req, res, next) ->
  
  {email, password, remember} = req.body
  
  console.log req.body
  
  return next 400 unless email? and password?
  
  digest = (require '../lib/hash') password
  
  User.byEmail email, (error, user) ->
    
    return next error if error?
    
    unless user?
      req.flash 'error', 'Incorrect email and/or password'
      res.status = 401
      if req.xhr
        res.send 401
      else
        res.render 'user/login'
      return
    
    # TODO timing attacks [@pyro]
    unless user.password is digest
      req.flash 'error', 'Incorrect email and/or password'
      res.status = 401
      if req.xhr
        res.send 401
      else
        res.render 'user/login'
      return
    
    console.log 'logged in', user: user, email: email, password: password, digest: digest
    
    req.session.user_id = user.id
    req.user = user
    
    if remember?.toLowerCase() is 'checked'
      res.cookie 'pouser', user.id, maxAge: 604800000
      res.cookie 'popwd', user.password, maxAge: 604800000
    
    req.flash 'success', 'Welcome!'
    if req.xhr
      res.send 200
    else
      res.status = 200
      res.redirect req.session.redirect_to or '/'