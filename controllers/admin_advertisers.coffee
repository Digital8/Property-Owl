system = require '../system'

models =
  advertiser: system.load.model 'advertiser'

helpers = {}

exports.index = (req, res) ->
  models.advertiser.all (error, results) ->
    throw error if error
    
    res.render 'administration/advertisers/index', advertisers: results

exports.add = (req, res) ->
  res.render 'administration/advertisers/add'

exports.create = (req, res) ->
  # req.assert('email', 'Invalid Email Address').isEmail()
  # req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
  # req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  # req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  # req.assert('lname', 'Last  name is invalid').isAlpha().len(2,20).notEmpty()
  
  errors = req.validationErrors true
  
  if errors
    keys = Object.keys errors
    
    for key in keys
      req.flash 'error', errors[key].msg
    
    req.session.signup = req.body
    
    res.redirect 'back'
  
  else # no errors
    advertiser = req.body
    
    models.advertiser.create advertiser, (error, results) ->
      req.flash 'success', 'Great Success!'
      res.redirect 'back'