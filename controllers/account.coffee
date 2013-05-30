system = require '../system'

helpers = hash: system.load.helper 'hash'

RAF = system.models.raf

models = 
  user: system.load.model 'user'
  registrations: system.load.model 'registrations'

exports.index = (req,res) -> res.render 'user/settings'

exports.view = (req,res) ->

exports.add = (req,res) ->

exports.create = (req,res) ->

exports.edit = (req,res) ->

exports.update = (req,res) ->
  req.body.email ?= ''
  req.body.fname ?= ''
  req.body.lname ?= ''
  req.body.id = res.locals.objUser.id
  
  req.assert('email', 'Invalid Email Address').isEmail()
   
  if req.body.password != ''
    req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
    req.assert('confirmPassword', 'Password does not match').isIn [req.body.password]
  
  req.assert('fname', 'First name is invalid').isAlpha().len(2,20).notEmpty()
  req.assert('lname', 'Last name is invalid').isAlpha().len(2,20).notEmpty()
  
  models.user.getUserByEmail req.body.email, (err, email) ->
    
    if email.length > 0 and req.body.email != res.locals.objUser.email
      req._validationErrors ?= []
      req._validationErrors.push
        param: 'email'
        msg: 'Email address is already in use'
        value: req.body.email
    
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
          # validation has already been checked so we're checking if we need to update pwd
          if req.body.password != '' 
                 req.body.password = helpers.hash(req.body.password)
                 models.user.updatePassword req.body, (err, results) ->
                   if err
                     console.log err
                     req.flash('error', "An unknown error has occured. Error code: #{err.code}")
                   else
                     req.flash('success', 'Your details have successfully been updated')
                   res.redirect 'back'
          else
            req.flash('success', 'Your details have successfully been updated')
            res.redirect 'back'

exports.destroy = (req,res) ->

exports.preferences = (req, res) ->
  res.render 'user/preferences'

exports.updatePreferences = (req, res) ->
  results = [ req.body.suburb, req.body.state, req.body.pType, req.body.dType, req.body.minPrice, req.body.maxPrice, req.body.minBeds, req.body.maxBeds, req.body.bathrooms,req.body.cars, req.body.devStage, res.locals.objUser.id ]
  system.db.query "UPDATE po_users SET pref_suburb = ?, pref_state = ?, pref_ptype = ?, pref_dtype = ?, pref_min_price = ?, pref_max_price = ?, pref_min_beds = ?, pref_max_beds = ?, pref_bathrooms = ?, pref_cars = ?, pref_dev_stage = ? WHERE user_id = ?", results, (err, results) ->
    if err then throw err
    req.flash('success','Preferences have been updated')
    res.redirect 'back'

exports.registrations = (req, res) ->
  models.registrations.findByUser res.locals.objUser.id, (err, results) ->
    if err then console.log err
    res.render 'user/registrations', registrations: results or {}

exports.referals = (req, res) ->
  RAF.getByUser res.locals.objUser.id, (error, referals) ->
    res.render 'user/referals', referals: referals or {}