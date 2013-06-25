module.exports = ->
  
  (req, res, next) ->
    
    req.user_id ?= null
    
    source = null
    
    # pull off a session
    if req.session.user_id?
      req.user_id ?= req.session.user_id
      source ?= 'session'
    
    # pull off a cookie
    if req.cookies['user.id']?
      req.user_id ?= req.cookies['user.id']
      source ?= 'cookie'
    
    return next null unless req.user_id?
    
    User.get req.user_id, (error, user) ->
      
      return next error if error?
      return next 401 unless user?
      
      if source is 'cookie'
        
        if user.password isnt req.cookies['user.password']
          console.log 'hacking?'
          delete req.session.user_id
          res.clearCookie 'user.id'
          res.clearCookie 'user.name'
          return next 401
      
      req.user = user
      
      next null