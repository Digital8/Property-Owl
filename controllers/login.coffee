exports.index = (req, res) ->
  
  {email, password} = req.body
  
  return res.render 'user/login' unless email? and password?
  
  digest = (require '../lib/hash') password
  
  User.byEmail email, (error, user) ->
    
    return res.send 500, error if error?
    
    unless user?
      req.flash 'error', 'Incorrect email and/or password'
      res.render 'user/login'
      return
    
    # TODO timing attacks [@pyro]
    unless user.password is digest
      req.flash 'error', 'Incorrect email and/or password'
      res.render 'user/login'
      return
    
    console.log 'logged in', user: user, email: email, password: password, digest: digest
    
    req.session.user_id = user.id
    req.user = user
    
    res.redirect req.session.redirect_to or '/'