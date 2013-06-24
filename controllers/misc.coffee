exports.login = (req, res) ->
  
  req.flash 'info', 'You must be logged in to do that'
  
  res.redirect '/'