system = require '../system'

models = advertiser: system.load.model 'advertiser'

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
      if error
        req.flash 'error', error.message
        
        res.redirect 'back'
      else
        req.flash 'success', 'Great Success!'
        
        res.redirect '/administration/advertisers'

exports.edit = (req, res) ->
  models.advertiser.find req.params.id, (error, results) ->
    if error
      throw error
    else
      if results.length < 1
        res.render 'errors/404'
      else
        advertiser = results.pop()
      
        for key, value of advertiser
          unless value then advertiser[key] = ''
        
        res.render 'administration/advertisers/edit', advertiser: advertiser

exports.update = (req, res) ->
  req.body.id = req.params.id
  
  models.advertiser.update req.body, (err, results) ->
    if err
      req.flash 'error', 'an error occured updating the advertiser'
      res.redirect 'back'
    else
      req.flash 'success', 'advertised updated'
      res.redirect '/administration/advertisers'

exports.delete = (req, res) ->
  models.advertiser.find req.params.id, (err, results) ->
    if results.length is 0
      req.flash 'error', "Uh Oh, that news post doesn't exist."
      res.redirect '/administration/advertisers'
    else
      res.render 'administration/advertisers/delete', advertiser: results.pop() or {}

exports.destroy = (req, res) ->
  models.advertiser.delete req.params.id, (err, results) ->
    req.flash 'success','news post deleted'
    
    res.redirect '/administration/advertisers'