###
 * Require Auth Helper
 *
 * Helper to restrict a page requiring authentication
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

module.exports = (req,res,next) ->
  if req.session.user_id
    next()
  else
    console.log 'Please Login', req.url
    req.flash('notice','You must be logged in to do this')
    res.redirect '/login'