exports.index = (req,res) ->
  
  callback = (err, results) ->
    if err then throw err
    res.render 'admin/users/index', users: results, search: req.query.name or ''
  
  if req.query.name?
    User.search '%'+req.query.name+'%', callback
  else
    User.all callback

exports.add = (req, res, next) ->
  
  User.groups (error, groups) ->
    
    return next error if error?
    
    user = {}
    
    menu = 'users'
    
    res.render 'admin/users/add', {user, groups, menu}

exports.create = (req,res) ->
  
  # req.session.users  = req.body
  # req.assert('email', 'Invalid Email').isEmail()
  # req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
  # req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  # req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  # req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
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
    
    req.assert('first_name', 'invalid').len 2 # regex /^[A-Z][a-zA-Z '&-]*[A-Za-z]$/
    req.assert('last_name', 'invalid').len 2 # regex /^[A-Z][a-zA-Z '&-]*[A-Za-z]$/
    
    req.assert('postcode', 'invalid').regex /[0-9]{4}/i
    
    errors = req.validationErrors()
    
    if errors
      for error in errors
        req.flash 'error', (_s.humanize "#{error.param} - #{error.msg}")
      req.session.form = req.body
      res.render 'back'
      return
    
    User.create
      password: (require '../lib/hash') (req.param 'password')
      account_type_id: 1
      email: req.param 'email'
      first_name: req.param 'first_name'
      last_name: req.param 'last_name'
      postcode: req.param 'postcode'
    , (error, user) ->
    
    user = req.body
    user.password = helpers.hash user.password
    user.group ?= 1
    
    User.createUser user, (err, results) ->
      
      req.flash 'success', 'User created!'
      
      res.redirect 'admin/users'

exports.edit = (req, res, next) ->
  
  User.get req.params.id, (error, user) ->
    
    return next error if error?
    
    unless user?
      req.flash 'error', 'User not found'
      res.status = 404
      res.redirect 'back'
      return
    
    User.groups (error, groups) ->
      
      return next error if error?
      
      res.render 'admin/users/edit', {user, groups}

exports.update = (req,res) ->
  
  req.body.email ?= ''
  req.body.fname ?= ''
  req.body.lname ?= ''
  req.body.id = req.params.id
  req.body.group ?= 1
  
  req.assert('email', 'Invalid Email Address').isEmail()
  
  if req.body.password != ''
    req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
    req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  
  req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
  User.getUserById req.body.id, (err, user) ->
    
    user = user.pop()
    
    User.getUserByEmail req.body.email, (err, email) ->
      if email.length > 0 and req.body.email != user.email 
        req.assert('email','Email address is in use').isIn []
      
      errors = req.validationErrors true
      
      if errors
        keys = Object.keys(errors)
        
        for key in keys
          req.flash('error', errors[key].msg)
        
        req.session.users = req.body
        
        res.redirect 'back'
      
      else
        User.updateUser req.body, (err, results) ->
          if err
            console.log err
            req.flash 'error', "An unknown error has occured. Error code: #{err.code}"
            res.redirect 'back'
          else
            # todo: Update the users group
            User.updateGroup req.body, (err, results) ->
              if err then console.log err
              req.flash 'success', 'Details have successfully been updated'
          
              res.redirect 'back'

exports.delete = (req, res) ->
  
  res.send 500

exports.destroy = (req, res) ->
  
  User.delete req.params.id, (err, results) ->
    if err 
      res.send status: 500
    else
      res.send status: 200