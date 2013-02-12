async = require 'async'

system = require '../system'
mailer = require '../lib/helpers/email'

models =
  user: system.load.model 'user'
  media: system.load.model 'media'
  registrations: system.load.model 'registrations'
  # owl: system.load.model 'owl'

RAF = system.models.raf

Owl = system.models.owl

helpers = 
  hash: system.load.helper 'hash'


exports.login = (req, res) ->
  models.user.login req.body.e, helpers.hash(req.body.p), (err, results) ->
  
    if results.length >= 1
      results = results.pop()
      req.session.user_id = results.user_id
      if req.body.r?
        if req.body.r.toLowerCase() == 'checked'
          res.cookie 'pouser', results.user_id, maxAge: 604800000
          res.cookie 'popwd', results.password, maxAge: 604800000
      res.send status: 200
  
    else
      res.send status: 401
        
exports.register = (req, res) ->
  req.assert('e', 'Invalid Email Address').isEmail()
  req.assert('p', 'Password must be at least 6 characters').len(6)
  req.assert('f', 'First name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
  req.assert('l', 'Last name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
  req.assert('p', 'Passwords do not match').isIn [req.body.p2]
  req.assert('t', 'Please accept the terms and conditions').isIn ['checked', 'Checked']
  req.assert('c', 'Postcode is invalid').len(4,5).isInt()

  errors = req.validationErrors(true)

  models.user.getUserByEmail req.body.e, (err, email) ->
    #if email.length > 0 then req.flash('error','Email address is already in use')
    if errors is false then errors = {}
    if email.length > 0 then errors.inUse = msg: 'Email is already in use'

    if Object.keys(errors)?.length > 0
      res.send status: 400, errors: errors
      
    else
      user = req.body
      user.password = helpers.hash user.p
      user.group = 1
      user.email = user.e
      user.fname = user.f
      user.lname = user.l
        
      models.user.createUser user, (err, results) ->
        if err
          console.log err
          res.send status: 500
        else
          req.session.user_id = results.insertId
          res.cookie 'user', results.insertId, maxAge: 604800000

          template = 'signup-confirmation'

          user =
            firstName: req.body.f
            email: req.body.e

          secondary = {}


          system.helpers.mailer template,'Registration Confirmation', user, secondary, (results) ->
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


  errors = req.validationErrors(true)

  if errors is false then errors = {}

  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors

  else
    template = 'owl-deal-registration'

    user =
      firstName: res.locals.objUser.firstName
      email: res.locals.objUser.email

    Owl.get req.body.id, (err, owl) ->
      image = 'images/placeholder.png'

      if owl.feature_image != '' then image = 'uploads/'+owl.feature_image

      secondary =
        link: 'owls/'+owl.id
        title: owl.title or ''
        address: owl.address or ''
        description: owl.description or ''
        image: image or ''


      system.helpers.mailer template,'Owl Deal Registration', user, secondary, (results) ->
        if results is true 
          res.send status: 200, errors: {}
        else
          res.send status: 400, errors: {msg: 'unable to send email'}

exports.referfriend = (req, res) ->
  req.body.user_id ?= res.locals.objUser.id
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('fullname', 'Full name is invalid').len(2,20)#.is(/^[A-Z]'?[- a-zA-Z]+$/).len(2,20)
  req.assert('comment', 'Comment cannot be empty').notEmpty()
  req.assert('entity_id', 'invalid entity').notEmpty()
  req.assert('entity_type', 'invalid entity type').notEmpty()

  errors = req.validationErrors(true)

  if errors is false then errors = {}
  console.log errors
  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors
  else
    req.body.first_name ?= req.body.fullname
    RAF.create req.body, (err, r) ->
      mailer
        to: req.body.email
        from: res.locals.objUser.email
        fromname: res.locals.objUser.displayName
        subject: 'Property Owl Referral'
        text: req.body.fullname + """,

        You have been referred a property at
        https://propertyowl.com.au/#{req.body.entity_type}s/#{req.body.entity_id}

        #{req.body.comment}
        """
      , 'Property Owl Referral'
      res.send status: 200

exports.addRegistration = (req, res) ->
  req.query.id ?= ''
  req.query.type ?= ''
  req.query.user_id ?= res.locals.objUser.id

  if req.query.id is '' or req.query.type is ''
    res.send status: 400
  else
    # Check if we have already registered    
    models.registrations.checkIfRegistered req.query, (err, results) ->
      if results.length is 0
        models.registrations.add req.query, (err, results) ->
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

  if res.locals.objUser.isDeveloper()
    models.registrations.changeStatus req.body, (err,results) ->
      if err
        res.send status: 500
      else
        res.send status: 200
  else
    res.send status: 403

exports.delRegistration = (req, res) ->
  req.query.id ?= ''
  req.query.user_id = res.locals.objUser.id
  
  # Get the registration so we can email to let the person know they're not interested
  models.registrations.find req.query.id, (err, results) ->
    if results.length is 1 
      results = results.pop()

      unless results.type in ['owl', 'barn']
        return res.send status: 500

      model = system.models[results.type]

      model.get results.resource_id, (err, record) ->
        if err then console.log err
        # Send withdraw email
        template = 'withdraw-interest'

        user =
          firstName: res.locals.objUser.displayName
          email: res.locals.objUser.email
        
        secondary =
          owl_id: record.id
          contactName: req.body.name
          address: record.address or ''
          link: "/#{results.type}s/#{record.id}"

        system.helpers.mailer template,'Withdrawal Confirmation', user, secondary, (results) ->
          del()


  del = ->
    models.registrations.delete req.query, (err, results) ->
      if err then res.send status: 400 else res.send status: 200

exports.search = (req, res) ->
  {address, suburb} = req.query
  
  system.db.query "SELECT * FROM owls WHERE address SOUNDS LIKE ? AND suburb SOUNDS LIKE ?", [address, suburb], (error, rows) ->
    Owl = system.models.owl
    
    _models = ((new Owl row) for row in rows)
    
    async.forEach _models, (model, callback) =>
      model.hydrate callback
    , (error) ->
      res.send [null, _models]
