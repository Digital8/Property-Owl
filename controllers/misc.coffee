###
 * Misc Controller
 *
 * Controller for pages that don't require a RESTful API
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

exports.login = (req, res) ->
  req.flash('info','You must be logged in to do that')
  res.redirect '/'

exports.logout = (req, res) ->
  delete req.session.user_id
  res.redirect '/'