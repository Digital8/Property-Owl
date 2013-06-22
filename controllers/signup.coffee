exports.index = (req, res) ->
  
  # if res.locals.objUser.isAuthed()
  #   return res.redirect '/'
  
  res.render 'user/sign-up', values: req.session.signup or {}

exports.create = (req, res) ->
  
  # if res.locals.objUser.isAuthed() then res.redirect '/'
  
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
  req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
  models.user.getUserByEmail req.body.email, (err, email) ->
    
    if email.length > 0 then req.flash 'error', 'Email address is already in use'
    
    errors = req.validationErrors true
    
    if errors
      keys = Object.keys(errors)
      
      for key in keys
        req.flash('error', errors[key].msg)
      
      req.session.signup = req.body
      
      res.redirect 'back'
    else
      user = req.body
      user.group = 1
      user.password = helpers.hash(user.password)
    
      models.user.createUser user, (err, results) ->
        
        req.flash('success','You are successful')
        
        res.redirect 'back'
