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
      console.log 'Got Form', req.body

      user = req.body
      user.password = helpers.hash user.p
      user.group = 1
      user.email = user.e
      user.fname = user.f
      user.lname = user.l
      user.postcode = user.c

      console.log 'Creating User', user        
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

          console.log 'Sending Email', template, user, secondary
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
    entity = 'owl' # default to owl
    Owl.get req.body.id, (err, owl) ->
      if owl.barn_id then entity = 'barn'

      # We have changed this to work for owl/barn
      template = 'owl-deal-registration'

      user =
        firstName: res.locals.objUser.firstName
        email: res.locals.objUser.email

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

      system.helpers.mailer template, subject + ' Deal Registration', user, secondary, (results) ->
        if not owl.user? then owl.user = {}

        if owl.barn_id then link = "barns/#{owl.id}" else link = "owls/#{owl.id}"

        user =
          firstName: res.locals.objUser.displayName
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

        system.helpers.mailer 'owl-deal-registration-developer', subject + ' Deal Registration', user, secondary, (devEmailResults) ->
          if results is true 
            res.send status: 200, errors: {}
          else
            res.send status: 400, errors: {msg: 'unable to send email'}

exports.referfriend = (req, res) ->
  req.body.user_id ?= res.locals.objUser.id
  req.body.entity_id = parseInt req.body.entity_id or 0
  req.body.entity_type ?= 'generic'
  if req.body.entity_type.length is 0
    req.body.entity_type = 'generic'
  req.assert('email', 'Invalid Email Address').isEmail()
  req.assert('fullname', 'Full name is invalid').len(2,20)#.is(/^[A-Z]'?[- a-zA-Z]+$/).len(2,20)
  req.assert('comment', 'Comment cannot be empty').notEmpty()
  #req.assert('entity_id', 'invalid entity').notEmpty()
  #req.assert('entity_type', 'invalid entity type').notEmpty()

  errors = req.validationErrors(true)

  if errors is false then errors = {}
  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors
  else
    req.body.first_name ?= req.body.fullname

    text = ""
    
    #if its generic
    if req.body.entity_type is 'generic'
      text = req.body.fullname + """,

      You have been referred a property at <a href="https://www.propertyowl.com.au">Property Owl</a>.

      #{req.body.comment}
      """
    
    #if its referring direct to a property or barn
    else
      text = req.body.fullname + """,

      You have been referred a property at <a href="https://www.propertyowl.com.au/#{req.body.entity_type}s/#{req.body.entity_id}">Property Owl</a>.

      #{req.body.comment}
      """

    RAF.create req.body, (err, r) ->
      if err?
        console.log 'Error Creating Referral', err
      mailer
        to: req.body.email
        from: res.locals.objUser.email
        fromname: res.locals.objUser.displayName
        subject: 'Property Owl Referral'
        text: text
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
