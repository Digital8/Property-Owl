exports.index = (req, res) ->
  res.render 'user/settings'
  delete req.session.form

exports.update = (req, res) ->
  
  # req.body.email ?= ''
  # req.body.fname ?= ''
  # req.body.lname ?= ''
  
  # req.assert('fname', 'First name is invalid').isAlpha().len(2, 20).notEmpty()
  # req.assert('lname', 'Last name is invalid').isAlpha().len(2, 20).notEmpty()
  
  # if req.body.password?.length
  #   req.assert('password', 'Password must be at least 6 characters').len(6).notEmpty()
  #   req.assert('confirm', 'Password does not match').isIn [req.body.password]
  
  # req.assert('email', 'Invalid Email Address').isEmail()
  
  User.byEmail req.body.email, (error, user) ->
    
    return res.send 500, error if error?
    
    if user? and user.id isnt req.user.id
      req._validationErrors ?= []
      req._validationErrors.push
        param: 'email'
        msg: 'Email address is already in use'
        value: req.body.email
    
    errors = req.validationErrors true
    
    if errors
      for key, error of errors then req.flash 'error', error.msg
      req.session.form = req.body
      res.redirect 'back'
      return
    
    User.get req.user.id, (error, user) ->
      
      patch = {}
      for key, value of req.body
        continue if user[key] is value
        patch[key] = value
      
      console.log patch: patch
      console.log before: user
      
      user.set patch
      
      console.log after: req.user
      
      user.validate {}, (error) ->
        if error?
          for key, message of error.errors then req.flash 'error', message
          req.session.form = user
          res.redirect 'back'
          return
        
        user.save (error) ->
          res.redirect '/account'
      
      # User.updateUser req.body, (error, results) ->
      #   if error
      #     console.log error
      #     req.flash 'error', "An unknown error has occured. Error code: #{error.code}"
      #   else
      #     # validation has already been checked so we're checking if we need to update pwd
      #     if req.body.password != '' 
      #            req.body.password = helpers.hash(req.body.password)
      #            User.updatePassword req.body, (error, results) ->
      #              if error
      #                console.log error
      #                req.flash('error', "An unknown error has occured. Error code: #{error.code}")
      #              else
      #                req.flash('success', 'Your details have successfully been updated')
      #              res.redirect 'back'
      #     else
      #       req.flash('success', 'Your details have successfully been updated')
      #       res.redirect 'back'

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