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
    
    primary =
      dear: req.body.first_name
      email: req.body.email
      first_name: req.user?.first_name
      last_name: req.user?.last_name
    
    if entity.constructor is User
      (require '../lib/mailer') 'refer-friend', 'Friend Referral', primary, req.body, (error) ->
    else
      (require '../lib/mailer') 'refer-property', 'Property Referral', primary, req.body, (error) ->