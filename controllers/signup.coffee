exports.get = (req, res, next) ->
  
  respond = (args = {}) ->
    
    res.render 'users/add', args
  
  return respond null unless req.session.referrer_id?
  
  User.get req.session.referrer_id, (error, referrer) ->
    return next error if error?
    respond
      referrer: referrer
      token: req.session.token

exports.post = (req, res, next) ->
  
  email = req.param 'email'
  
  User.byEmail email, (error, user) ->
    
    return next error if error?
    
    if email?.length and user?
      req._validationErrors ?= []
      req._validationErrors.push
        param: 'email'
        msg: 'already in use'
        value: user.email
    else
      req.assert('email', 'invalid').isEmail()
    
    req.assert('password', 'too short (6 characters minimum)').len 6
    if (req.param 'password')?.length
      req.assert('confirm', '').equals (req.param 'password')
    
    req.assert('first_name', 'invalid').regex /^[A-Z][a-zA-Z '&-]*[A-Za-z]$/
    req.assert('last_name', 'invalid').regex /^[A-Z][a-zA-Z '&-]*[A-Za-z]$/
    
    req.assert('terms_and_conditions', 'not accepted').isIn ['checked', 'Checked', 'on']
    
    req.assert('postcode', 'invalid').regex /[0-9]{4}/i
    
    return if req.guard req, res, next
    
    Token.byUUID (req.param 'token'), (error, token) ->
      
      return next error if error?
      
      User.create
        password: (require '../lib/hash') (req.param 'password')
        account_type_id: 1
        email: req.param 'email'
        first_name: req.param 'first_name'
        last_name: req.param 'last_name'
        postcode: req.param 'postcode'
        referrer_id: token?.entity?.id
      , (error, user) ->
        
        return next error if error?
        
        req.session.user_id = user.id
        res.cookie 'user', user.id, maxAge: 604800000
        
        if req.xhr
          res.send id: user.id
        else
          res.redirect '/'
        
        (require '../lib/mailer') 'signup-confirmation-special-launch', 'Registration Confirmation', user, {}, (error) ->