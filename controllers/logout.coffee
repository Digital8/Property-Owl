exports.get = (req, res) ->
  
  delete req.session.user_id
  
  res.clearCookie 'user.id'
  res.clearCookie 'user.password'
  
  res.redirect '/'