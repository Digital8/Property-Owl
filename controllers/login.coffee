exports.get = (req, res) ->
  
  if req.user?
    req.flash 'error', "You are already signed in!"
    res.redirect '/'
    return
  
  res.render 'user/login'

exports.post = (req, res, next) ->
  
  {email, password, remember} = req.body
  
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
    
    if remember?.toLowerCase() in ['checked', 'on']
      res.cookie 'user.id', user.id, maxAge: 604800000
      res.cookie 'user.password', user.password, maxAge: 604800000
    
    req.flash 'success', 'Welcome!'
    if req.xhr
      res.send 200
    else
      res.status = 200
      res.redirect req.session.redirect_to or '/'