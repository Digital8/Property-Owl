_s = require 'underscore.string'

exports.index = (req, res) ->
  
  console.log req.session.account
  
  user = {}
  
  for key, value of req.user
    user[key] = value
  
  
  
  if req.session.account?
    for key, value of req.session.account
      user[key] = value
  
  console.log user
  
  res.render 'user/settings', {user}
  
  delete req.session.account

exports.update = (req, res, next) ->
  
  User.byEmail req.body.email, (error, user) ->
    
    return next error if error?
    
    req._validationErrors ?= []
    
    if user? and user.id isnt req.user.id
      req._validationErrors.push
        param: 'email'
        msg: 'Email address is already in use'
        value: req.body.email
    
    if req.body.password?.length or req.body.confirm?.length
      
      for key in ['password', 'confirmation']
        if req.body[key]?.length < 6
          req._validationErrors.push
            param: key
            msg: (_s.humanize "#{key} too short")
            value: req.body[key]
      
      if req.body.password isnt req.body.confirm
        req._validationErrors.push
          param: 'password/confirmation'
          msg: 'Password & Confirmation do not match!'
          value: null
    
    errors = req.validationErrors()
    
    if errors?.length
      for error in errors then req.flash 'error', error.msg
      req.session.account = req.body
      res.redirect 'back'
      return
    
    {password, confirm} = req.body
    
    delete req.body.password
    
    if password?.length >= 6 and confirm?.length >= 6 and password is confirm
      req.body.password = (require '../lib/hash') password
    
    User.get req.user.id, (error, user) ->
      
      return next error if error?
      
      user.patch req.body, (error) ->
        
        if error?
          for key, message of error.errors
            req.flash 'error', (_s.humanize "#{key} - #{message}")
          req.session.account = req.body
          res.redirect 'back'
          return
        
        req.flash 'success', 'Account updated!'
        res.redirect '/account'

exports.preferences = (req, res) -> res.render 'user/preferences'

exports.updatePreferences = (req, res) ->
  
  map = [
    req.body.suburb
    req.body.state
    req.body.pType
    req.body.dType
    req.body.minPrice
    req.body.maxPrice
    req.body.minBeds
    req.body.maxBeds
    req.body.bathrooms
    req.body.cars
    req.body.devStage
    req.user.id
  ]
  
  exports.db.query """
  UPDATE users
  SET
    pref_suburb = ?,
    pref_state = ?,
    pref_ptype = ?,
    pref_dtype = ?,
    pref_min_price = ?,
    pref_max_price = ?,
    pref_min_beds = ?,
    pref_max_beds = ?,
    pref_bathrooms = ?,
    pref_cars = ?,
    pref_dev_stage = ?
  WHERE user_id = ?
  """, map, (error) ->
    
    return res.send 500, error if error?
    
    req.flash 'success', 'Preferences have been updated'
    res.redirect 'back'

exports.registrations = (req, res, next) ->
  
  Registration.forUser req.user, (error, registrations) ->
    
    return next error if error?
    
    res.render 'user/registrations', {registrations}

exports.referrals = (req, res) ->
  
  Referral.forUser req.user, (error, referrals) ->
    
    res.render 'user/referrals', {referrals}