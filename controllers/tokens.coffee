exports.uuid = (req, res, next) ->
  
  Token.byUUID (req.param 'uuid'), (error, token) ->
    
    return next error if error?
    
    return next 404 unless token?
    
    map = {}
    
    map[User.name] = (req, res, next) ->
      
      req.session.referrer_id = token.entity.id
      
      res.redirect "/users/add"
    
    handler = map[token.entity.constructor.name]
    
    return next 400 unless handler?
    
    handler req, res, next