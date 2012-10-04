###
 * Ajax Controller
 *
 * Controller for ajax activity
 *
 * @package   Property Owl
 * @author    Brendan Scarvell <brendan@digital8.com.au>
 * @copyright Copyright (c) 2012 - Current
 ###

system = require '../system'

models = 
  user: system.load.model 'user'

exports.login = (req, res) ->
  res.send status: true