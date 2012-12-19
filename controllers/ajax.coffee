system = require '../system'
mailer = require '../lib/helpers/email'

models =
  user: system.load.model 'user'
  media: system.load.model 'media'
  registrations: system.load.model 'registrations'

helpers = 
  hash: system.load.helper 'hash'
  mailer: system.load.helper 'mailer'

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
  console.log(req.body)

  errors = req.validationErrors(true)

  if errors is false then errors = {}

  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors

  else
    template = 'barn-deal-registration'

    user =
      firstName: res.locals.objUser.firstName
      email: res.locals.objUser.email

    secondary =
      barndealLink: ''
      BarnDealTitle: ''
      BarnDealAddress: ''
      BarnDealDescription: ''


    system.helpers.mailer template,'Barn Deal Registration', user, secondary, (results) ->
      if results is true 
        res.send status: 200, errors: {}
      else
        res.send status: 400, errors: {msg: 'unable to send email'}

exports.referfriend = (req, res) ->
  req.assert('e', 'Invalid Email Address').isEmail()
  req.assert('m', 'Phone Number is invalid').is(/^[\+0-9][ 0-9]*[0-9]$/).len(8,16)
  req.assert('f', 'First name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
  req.assert('l', 'Last name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
  req.assert('c', 'Comment cannot be empty').notEmpty()
  console.log(req.body)

  errors = req.validationErrors(true)

  if errors is false then errors = {}

  if Object.keys(errors)?.length > 0
    res.send status: 400, errors: errors

  else
    mailer
      to: req.body.e
      from: 'mailer@propertyowl.com.au'
      fromname: 'Property Owl'
      subject: 'Property Owl Referral'
      text: req.body.f + """,

      You have been referred some property
      """
    , 'Property Owl Referral'
    res.send status: 200

# exports.savedeal = (req, res) ->
#   req.assert('id', 'Property ID Not Numeric').isInt()
  
#   errors = req.validationErrors true

#   if errors
#     res.send status: false
#   else
#     models.saveddeals.checkDeal req.body.id, res.locals.objUser.id, (err, results) ->
#       if results.length is 0
#         models.saveddeals.saveDeal req.body.id, res.locals.objUser.id, (err, results) ->
#           if err?
#             res.send status: false
#           else
#             res.send status: true
#       else
#         res.send status: true

# exports.removedeal = (req, res) ->
#   req.assert('id', 'Property ID Not Numeric').isInt()
  
#   errors = req.validationErrors true
  
#   if errors
#     res.send status: false
#   else
#     models.saveddeals.removeSavedDeal req.body.id, res.locals.objUser.id, (err, results) ->
#       if err?
#         res.send status: false
#       else
#         res.send status:true

# exports.addDeal = (req, res) ->
#   req.body.property_id ?= req.body.pid
#   req.body.created_by = res.locals.objUser.id
  
#   models.deals.addDeal req.body, (err, results) ->
#     if err then throw err
    
#     res.send results

# exports.delDeal = (req, res) ->
#   models.deals.getDealById req.body.id, (err, results) ->
#     if err then throw err
    
#     if results.length is 1 then results = results.pop()
    
#     models.deals.deleteDealById req.body.id, (err) ->
#       res.send results

exports.updateHero = (req, res) ->
  models.media.clearHero req.body.pid, (err) ->
    models.media.setHero req.body.mid, (err, results) ->
      res.send results

exports.deleteMedia = (req, res) ->
  req.body.mid ?= 0
  
  models.media.deleteMedia req.body.mid, (err, results) ->
    if err then console.log err
    res.send results
      
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
            res.send status: 400
      else
        res.send status: 400

exports.delRegistration = (req, res) ->
  req.query.id ?= ''
  req.query.user_id = res.locals.objUser.id
  
  models.registrations.delete req.query, (err, results) ->
    if err then res.send status: 400 else res.send status: 200

exports.search = (req, res) ->
  console.log req.query
  
  {address, suburb} = req.query
  
  system.db.query "SELECT * FROM owls WHERE address SOUNDS LIKE ? AND suburb SOUNDS LIKE ?", [address, suburb], (error, rows) ->
    
    console.log rows
    
    res.send []

exports.enquiry = (req, res) ->
  system.db.query "SELECT * FROM affiliates WHERE affiliate_id = ?", [req.body.aid], (err, affiliate) ->
    if err or affiliate.length is 0
      res.send status: 500, error: 'Invalid product'
    else
      template = 'service-enquiry'

      user =
        firstName: res.locals.objUser.firstName
        email: affiliate[0].email
        lastName: res.locals.objUser.lastName
        phone: res.locals.objUser.phone

      secondary =
        contactName: affiliate[0].name
        description: req.body.enquiry
        contact_method: 'email'
        enquiryEmail: res.locals.objUser.email

      system.helpers.mailer template,'New Enquiry', user, secondary, (results) ->
        system.db.query  "INSERT INTO enquiries (user_id, affiliate_id, enquiry) VALUES (?,?,?)", [res.locals.objUser.id, req.body.aid, req.body.enquiry], (err, rows) ->
          if err 
            res.send status: 500, error: err
          else 
            res.send status: 200