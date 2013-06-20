async = require 'async'

exports.login = (req, res) ->
  
  email = req.body.e
  password = req.body.p
  
  digest = (require '../lib/hash') password
  
  User.byEmail email, (error, user) ->
    
    return res.send 500, error if error?
    
    unless user?
      res.send status: 401
      return
    
    # TODO timing attacks [@pyro]
    unless user.password is digest
      res.send status: 401
      return
    
    req.session.user_id = user.id
    
    if req.body.r?.toLowerCase() is 'checked'
      res.cookie 'pouser', user.id, maxAge: 604800000
      res.cookie 'popwd', user.password, maxAge: 604800000
    
    res.send status: 200

# TODO rename these fields FFS
exports.register = (req, res) ->
  
  req.assert('e', 'Invalid Email Address').isEmail()
  req.assert('p', 'Password must be at least 6 characters').len(6)
  req.assert('f', 'First name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2, 20)
  req.assert('l', 'Last name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2, 20)
  req.assert('p', 'Passwords do not match').isIn [req.body.p2]
  req.assert('t', 'Please accept the terms and conditions').isIn ['checked', 'Checked']
  req.assert('c', 'Postcode is invalid').len(4, 5).isInt()
  
  errors = (req.validationErrors true) or {}
  
  User.byEmail req.body.e, (error, email) ->
    
    return res.send 500, error if error?
    
    if email? then errors.inUse = msg: 'Email is already in use'
    
    if Object.keys(errors).length
      return res.send status: 400, errors: errors
    
    # no errors
    console.log 'Got Form', req.body
    
    map =
      password: (require '../lib/hash') req.body.p
      group: 1
      email: req.body.e
      first_name: req.body.f
      last_name: req.body.l
      postcode: req.body.c
    
    User.create map, (error, user) ->
      
      return res.send status: 500, error: error if error?
      
      req.session.user_id = user.id
      res.cookie 'user', user.id, maxAge: 604800000
      
      (require '../lib/mailer') 'signup-confirmation', 'Registration Confirmation', user, {}, (results) ->
        if results is true
          res.send status: 200, errors: {}
        else
          res.send status: 400, errors: {msg: 'unable to send email'}

exports.securedeal = (req, res) ->
  
  req.assert('e', 'Invalid Email Address').isEmail()
  req.assert('m', 'Phone Number is invalid').is(/^[\+0-9][ 0-9]*[0-9]$/).len(8,16)
  req.assert('f', 'First name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
  req.assert('l', 'Last name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
  req.assert('c', 'Comment cannot be empty').notEmpty()
  
  errors = req.validationErrors true

  if errors is false then errors = {}

  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors

  else
    entity = 'owl' # default to owl
    Owl.get req.body.id, (err, owl) ->
      if owl.barn_id then entity = 'barn'

      # We have changed this to work for owl/barn
      template = 'owl-deal-registration'

      user =
        first_name: req.user?.first_name
        email: req.user?.email

      image = 'images/placeholder.png'

      if owl.feature_image != '' then image = 'uploads/'+owl.feature_image
      if owl.barn_id then link = "/barns/#{owl.barn_id}" else link = "/owls/#{owl.id}"

      secondary =
        link: link
        title: owl.title or ''
        address: owl.address or ''
        description: owl.description or ''
        image: image or ''
        entity: entity

      if entity is 'owl' then subject = 'Owl' else subject = 'Barn'

      (require '../lib/mailer') template, subject + ' Deal Registration', user, secondary, (results) ->
        if not owl.user? then owl.user = {}

        if owl.barn_id then link = "barns/#{owl.id}" else link = "owls/#{owl.id}"

        user =
          first_name: req.user?.displayName
          email: owl.user.email or ''
          phone: req.body.m or ''

        secondary =
          owl_id: owl.barn_id or owl.id
          contactName: owl.user.first_name
          address: owl.address or ''
          title: owl.name or ''
          description: req.body.c
          contact_method: req.body.contact or 'phone'
          enquiryEmail: req.body.e or ''
          entity: entity
          link: link

        (require '../lib/mailer') 'owl-deal-registration-developer', subject + ' Deal Registration', user, secondary, (devEmailResults) ->
          if results is true 
            res.send status: 200, errors: {}
          else
            res.send status: 400, errors: {msg: 'unable to send email'}

exports.referfriend = (req, res) ->
  
  req.body.user_id ?= req.user?.id
  req.body.entity_id = parseInt req.body.entity_id or 0
  req.body.entity_type ?= 'generic'
  if req.body.entity_type.length is 0
    req.body.entity_type = 'generic'
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('fullname', 'Full name is invalid').len(2,20)#.is(/^[A-Z]'?[- a-zA-Z]+$/).len(2,20)
  req.assert('comment', 'Comment cannot be empty').notEmpty()
  #req.assert('entity_id', 'invalid entity').notEmpty()
  #req.assert('entity_type', 'invalid entity type').notEmpty()
  
  errors = req.validationErrors true
  
  if errors is false then errors = {}
  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors
  else
    req.body.first_name ?= req.body.fullname
    
    template = 'refer-property'
    if req.body.entity_type is 'generic'
      template = 'refer-general'
    
    Referral.create req.body, (err, r) ->
      if err?
        console.log 'Error Creating Referral', err
      
      #swap out the friends email
      req.user?.email = req.body.email
      console.log 'Sending Email', template, req.user, req.body
      (require '../lib/mailer') template, 'Referral', req.user, req.body, (results) ->
        if results is true 
          res.send status: 200, errors: {}
        else
          res.send status: 400, errors: {msg: 'unable to send email'}

exports.addRegistration = (req, res) ->
  req.query.id ?= ''
  req.query.type ?= ''
  req.query.user_id ?= req.user?.id

  if req.query.id is '' or req.query.type is ''
    res.send status: 400
  else
    # Check if we have already registered    
    Registration.checkIfRegistered req.query, (err, results) ->
      if results.length is 0
        Registration.add req.query, (err, results) ->
          if err then console.log err
          if results.affectedRows is 1
            
            res.send status: 200

          else
            res.send status: 400, message: 'DB error'
      else
        res.send status: 400, message: 'Already registered to property'

exports.registerStatus = (req, res) ->
  req.body.id ?= 0
  req.body.val ?= 0

  if req.user?.isDeveloper()
    Registration.changeStatus req.body, (err,results) ->
      if err
        res.send status: 500
      else
        res.send status: 200
  else
    res.send status: 403

exports.delRegistration = (req, res) ->
  
  req.query.id ?= ''
  req.query.user_id = req.user?.id
  
  # Get the registration so we can email to let the person know they're not interested
  Registration.find req.query.id, (err, results) ->
    if results.length is 1 
      results = results.pop()
      
      unless results.type in ['owl', 'barn']
        return res.send status: 500
        
      model = exports.models[results.type]
      
      model.get results.resource_id, (err, record) ->
        if err then console.log err
        # Send withdraw email
        template = 'withdraw-interest'
        
        user =
          first_name: req.user?.displayName
          email: req.user?.email
        
        secondary =
          owl_id: record.id
          contactName: req.body.name
          address: record.address or ''
          link: "/#{results.type}s/#{record.id}"
        
        (require '../lib/mailer') template,'Withdrawal Confirmation', user, secondary, (results) ->
          del()
  
  del = ->
    Registration.delete req.query, (err, results) ->
      if err then res.send status: 400 else res.send status: 200

exports.search = (req, res) ->
  
  {address, suburb} = req.query
  
  exports.db.query """
  SELECT * FROM owls
  WHERE
    address SOUNDS LIKE ?
      AND
    suburb SOUNDS LIKE ?
  """, [address, suburb], (error, rows) ->
    
    models = ((new Owl row) for row in rows)
    
    async.forEach models, (model, callback) =>
      model.hydrate callback
    , (error) ->
      res.send [null, models]