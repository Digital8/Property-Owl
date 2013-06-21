exports.create = (req, res, next) ->
  
  req.assert('email', 'missing').notNull()
  req.assert('email', 'empty').notEmpty()
  req.assert('email', 'invalid').isEmail()
  
  req.assert('comment', 'missing').notNull()
  req.assert('comment', 'empty').notEmpty()
  
  for key in ['first_name', 'last_name']
    req.assert(key, 'missing').notNull()
    req.assert(key, 'empty').notEmpty()
    req.assert(key, 'too short').len 2
    req.assert(key, 'too long').len null, 32
  
  return if req.guard arguments...
  
  {entity, user} = req
  
  Referral.create
    user_id: user.id
    entity_id: entity.id
    entity_type: entity.constructor.name.toLowerCase()
    comment: req.param 'comment'
    first_name: req.param 'first_name'
    last_name: req.param 'last_name'
    email: req.param 'email'
  , (error, referral) ->
    
    return next error if error?
    
    res.send id: referral.id
    
    # emails
    #swap out the friends email
    req.user?.email = req.body.email
    template = 'refer-property'
    (require '../lib/mailer') template, 'Referral', req.user, req.body, (error) ->