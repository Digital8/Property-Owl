###
 * Require Auth Helper
 *
 * Helper to restrict a page requiring authentication
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (req, res, next) ->
  
  return next() if req.session.user_id?
  
  # if req.url.indexOf('?login=1') is -1
  #   res.redirect req.url + '?login=1'
  # else
  
  req.session.redirect_to = req.url
  
  res.redirect '/login'
  
  # res.render 'user/login',
  #   redirect: req.url or '/'
  #   modal: true