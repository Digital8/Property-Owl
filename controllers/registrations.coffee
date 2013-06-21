# email = () ->
  
#   req.assert('e', 'Invalid Email Address').isEmail()
#   req.assert('m', 'Phone Number is invalid').is(/^[\+0-9][ 0-9]*[0-9]$/).len(8,16)
#   req.assert('f', 'First name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
#   req.assert('l', 'Last name is invalid').is(/^[a-zA-Z][a-zA-Z -]*[a-zA-Z]$/).len(2,20)
#   req.assert('c', 'Comment cannot be empty').notEmpty()
  
#   errors = req.validationErrors true

#   if errors is false then errors = {}

#   if Object.keys(errors)?.length > 0
#     res.send status: 400, errors: errors

#   else
#     entity = 'owl' # default to owl
#     Owl.get req.body.id, (err, owl) ->
#       if owl.barn_id then entity = 'barn'

#       # We have changed this to work for owl/barn
#       template = 'owl-deal-registration'

#       user =
#         first_name: req.user?.first_name
#         email: req.user?.email

#       image = 'images/placeholder.png'

#       if owl.feature_image != '' then image = 'uploads/'+owl.feature_image
#       if owl.barn_id then link = "/barns/#{owl.barn_id}" else link = "/owls/#{owl.id}"

#       secondary =
#         link: link
#         title: owl.title or ''
#         address: owl.address or ''
#         description: owl.description or ''
#         image: image or ''
#         entity: entity

#       if entity is 'owl' then subject = 'Owl' else subject = 'Barn'

#       (require '../lib/mailer') template, subject + ' Deal Registration', user, secondary, (results) ->
#         if not owl.user? then owl.user = {}

#         if owl.barn_id then link = "barns/#{owl.id}" else link = "owls/#{owl.id}"

#         user =
#           first_name: req.user?.name
#           email: owl.user.email or ''
#           phone: req.body.m or ''
        
#         secondary =
#           owl_id: owl.barn_id or owl.id
#           contactName: owl.user.first_name
#           address: owl.address or ''
#           title: owl.name or ''
#           description: req.body.c
#           contact_method: req.body.contact or 'phone'
#           enquiryEmail: req.body.e or ''
#           entity: entity
#           link: link
        
#         (require '../lib/mailer') 'owl-deal-registration-developer', subject + ' Deal Registration', user, secondary, (devEmailResults) ->
#           if results is true 
#             res.send status: 200, errors: {}
#           else
#             res.send status: 400, errors: {msg: 'unable to send email'}

exports.destroy = (require '../behaviors/destroy') Registration

exports.create = (req, res, next) ->
  
  req.assert('comment', 'missing').notNull()
  req.assert('comment', 'empty').notEmpty()
  
  req.assert('phone', 'missing').notNull()
  req.assert('phone', 'empty').notEmpty()
  req.assert('phone', 'invalid').is /^[\+0-9][ 0-9]*[0-9]$/
  req.assert('phone', 'too short').len 8
  req.assert('phone', 'too long').len null, 16
  
  return if req.guard arguments...
  
  {entity, user} = req
  
  Registration.registered {entity, user}, (error, registered) ->
    
    return next error if error?
    
    return next message: 'Already registered', status: 409 if registered
    
    Registration.create
      user_id: user.id
      entity_id: entity.id
      entity_type: entity.constructor.name.toLowerCase()
      comment: req.param 'comment'
      phone: req.param 'phone'
    , (error, registration) ->
      
      return next error if error?
      
      res.send id: registration.id