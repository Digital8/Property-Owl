###
 * Sign Up Controller
 *
 * Controller for homepage of website
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

helpers = 
  hash: system.load.helper('hash')
  
models = 
  user: system.load.model 'user'

# GET
exports.index = (req,res) ->
  res.render 'user/sign-up', values: req.session.signup or {}

# GET    
exports.view = (req,res) ->

# GET
exports.add = (req,res) ->

# PUT
exports.create = (req,res) ->
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
  req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
  errors = req.validationErrors(true)
  if errors
    keys = Object.keys(errors)
    
    for key in keys
      req.flash('error', errors[key].msg)
    
    req.session.signup = req.body

    res.redirect 'back'
  else
    user = req.body
    user.password = helpers.hash(user.password)
    
    models.user.createUser user, (err, results) ->
      req.flash('success','You are successful')
      res.redirect 'back'

# GET
exports.edit = (req,res) ->

# POST
exports.update = (req,res) ->

# DEL
exports.destroy = (req,res) ->

