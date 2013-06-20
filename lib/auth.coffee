module.exports = ->
  
  (req, res, next) ->
    
    id = null
    id ?= req.session.user_id
    id ?= req.cookies.user_id
    
    return next? null unless id?
    
    User.get id, (error, user) ->
      
      return res.send 500, error if error?
      return res.send 404 unless user?
      
      req.user = user
      # res.locals.user = user
      
      return next? null
      
      #   if req.cookies.pouser?
      #     if results.password == req.cookies.popwd
      #       req.session.user_id = user_id
      #       res.locals.objUser = new classes.user results
      #     else
      #       # GO AWAY HAX0R
      #       delete req.session.user_id
      #       res.clearCookie 'pouser'
      #       res.clearCookie 'popwd'
      #       res.redirect '/'
      #   else
      #     res.locals.objUser = new classes.user results
      
      # req.user = res.locals.objUser
      
      # do next