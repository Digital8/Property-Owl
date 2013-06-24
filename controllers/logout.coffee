exports.get = (req, res) ->
  
  delete req.session.user_id
  
  res.clearCookie 'pouser'
  res.clearCookie 'popwd'
  
  res.redirect '/'