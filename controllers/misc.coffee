system = require '../system'

exports.login = (req, res) ->
  req.flash 'info', 'You must be logged in to do that'
  
  res.redirect '/'

exports.logout = (req, res) ->
  delete req.session.user_id
  
  res.redirect '/'