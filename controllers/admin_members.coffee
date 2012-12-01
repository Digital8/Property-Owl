system = require '../system'

models = user: system.load.model 'user'

helpers = hash: system.load.helper 'hash'

exports.index = (req,res) ->
  models.user.getAllUsers (err, results) ->
    if err then throw err
    
    res.render 'administration/members/index', users: results, menu: 'members'

exports.view = (req,res) ->

exports.add = (req,res) ->
  models.user.getAllGroups (err, groups) ->
    if err then throw err
    
    res.render 'administration/members/add', values: req.session.signup or {}, groups: groups or {}, menu: 'members'

exports.create = (req,res) ->
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
  req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
  models.user.getUserByEmail req.body.email, (err, email) ->
     if email.length > 0 then req.flash('error','Email address is already in use')
     
     errors = req.validationErrors true
     
     if errors
       keys = Object.keys(errors)

       for key in keys
         req.flash('error', errors[key].msg)

       req.session.signup = req.body

       res.redirect 'back'
     else
       user = req.body
       user.password = helpers.hash user.password
       user.group ?= 1
       
       models.user.createUser user, (err, results) ->
         req.flash('success','You are successful')
         res.redirect 'back'

exports.edit = (req,res) ->
  models.user.getUserById req.params.id, (err, results) ->
    if not results
      req.flash 'error', 'User not found'
      res.redirect 'back'
    else
      models.user.getAllGroups (err, groups) ->
        res.render 'administration/members/edit', values: results.pop(), groups: groups, menu: 'members'

exports.update = (req,res) ->
  req.body.email ?= ''
  req.body.fname ?= ''
  req.body.lname ?= ''
  req.body.id = req.params.id
    
  req.assert('email', 'Invalid Email Address').isEmail()
 
  if req.body.password != ''
    req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
    req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  
  req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
  models.user.getUserById req.body.id, (err, user) ->
    user = user.pop()
    
    models.user.getUserByEmail req.body.email, (err, email) ->
      if email.length > 0 and req.body.email != user.email 
        req.assert('email','Email address is in use').isIn []
      
      errors = req.validationErrors true
      
      if errors
        keys = Object.keys(errors)
        
        for key in keys
          req.flash('error', errors[key].msg)
    
        req.session.signup = req.body
        
        res.redirect 'back'
      
      else
        models.user.updateUser req.body, (err, results) ->
          if err
            console.log err
            req.flash 'error', "An unknown error has occured. Error code: #{err.code}"
          else
            # todo: Update the users group
            req.flash 'success', 'Your details have successfully been updated'
          
          res.redirect 'back'

exports.destroy = (req,res) ->