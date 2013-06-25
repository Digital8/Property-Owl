exports.index = (req, res) ->
  
  res.render 'user/forgot_pwd'

exports.show = (req, res, next) ->
  
  Token.byUUID req.params.id, (error, token) ->
    
    return next error if error?
    
    return next 404 unless token?
    
    return next 400 unless token.key is 'recovery'
    
    # TODO token/recovery TTL [@pyro]
    
    req.session.user_id = token.user_id
    
    req.flash 'success', "We've logged you in for now. Please change your password."
    
    res.redirect '/account'

exports.create = (req, res, next) ->
  
  req.assert('email', 'invalid').isEmail()
  
  return if req.guard arguments...
  
  respond = ->
    req.flash 'success', "We have emailed your password reset instructions."
    res.redirect 'back'
  
  member = (user, callback) ->
    
    Token.createForEntityWithKey user, 'recovery', user_id: user.id, (error, token) ->
      
      return callback error if error?
      
      (require '../lib/mailer') 'forgot-password', 'Password Recovery', user, token: token.uuid
      
      callback null
  
  random = (email, callback) ->
    
    (require '../lib/mailer') 'forgot-password', 'Password Recovery', {email}
    
    callback null
  
  {email} = req.body
  
  User.byEmail email, (error, user) ->
    
    return next error if error?
    
    return member user, respond if user?
    
    return random email, respond